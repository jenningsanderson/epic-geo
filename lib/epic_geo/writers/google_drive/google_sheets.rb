require 'google_drive'


#Abstract Authentication & Housekeeping class
class GoogleDriveAccess
	require 'yaml'

	attr_reader :config, :credentials #Config files
	attr_reader :session, :collection #Google Drive objects

	def initialize(args)
		location = args[:config] || '_config.yml'
		@config = YAML::load(File.open(location))
		
		if File.exists?(config['credentials'])
			print "Loading credentials from config location..."
			@credentials = YAML::load(File.open(config['credentials']))
		else
			puts "Warning: No credentials available to access Google Drive"
		end

		post_initialize(args)
	end


	def post_initialize(args)
		begin
			@session = GoogleDrive.login(credentials['google_username'], credentials['google_password'])
			@collection = session.collection_by_title(args[:collection])
		rescue => e
			puts "Error logging in and accessing sheet!"
			puts $!
			exit 1
		end
	end
end


#Destructive writing functions live here
module EpicGeo
	module Writers
		module GoogleDrive
			class SheetMaker < GoogleDriveAccess

				attr_reader :sheet, :filename

				def initialize(args)
					super(args) #Call the abstract class to set instance variables
					
					@sheet = session.create_spreadsheet #Make the new sheet
					collection.add(@sheet)				#Add it to the collection
					@filename = args[:name] || Time.now.to_s
					@sheet.title = filename
				end

				def add_worksheet(ws_name = Time.now.to_s) #Must pass a name to the worksheet
					puts "Making new worksheet: #{ws_name}"
					SingleSheet.new( sheet.add_worksheet(ws_name) )
				end

				def clear_codes #Warning! Destructive! #Hardcoded too!  Dangerous!
					(4 .. sheet.num_cols).each do |column|
						(2..sheet.num_rows).each do |row|
							unless sheet[row,column] == ""
								sheet[row, column] = ""
							end
						end
					end
					sheet.save
				end
			end

			class SingleSheet #This is just to write a single worksheet, it shouldn't need any fancy information

				attr_reader :ws, :row_index
				
				def initialize(worksheet)
					@ws = worksheet
					@row_index = 1
					write_headers
				end

				def write_headers(headers=["Date", "Text", "Geo"])
					headers.each_with_index do |header, index|
						ws[1, index+1] = header 
					end
					ws.save
				end

				def add_tweet(tweet)
					begin
						@row_index += 1
						ws[row_index, 1] = tweet[:Date]
						ws[row_index, 2] = tweet[:Coordinates]
						ws[row_index, 3] = tweet[:Text]
						ws.save
						print "."
					rescue => e
						puts "Error writing this tweet: #{tweet}"
						puts $!
						puts e.backtrace
					end
				end

				def save
					ws.save
				end
			end
		end
	end
end