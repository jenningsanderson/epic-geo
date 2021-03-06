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
			@session = GoogleDrive.login_with_oauth(get_token)
			@collection = session.collection_by_title(args[:collection])
		rescue => e
			puts "Error logging in and accessing sheet!"
			puts $!
			puts e.backtrace
			exit 1
		end
	end

	def get_token
		client = OAuth2::Client.new(
    		credentials['google_oauth_id'], credentials['google_oauth_secret'],
    		:site => "https://accounts.google.com",
    		:token_url => "/o/oauth2/token",
    		:authorize_url => "/o/oauth2/auth"
    	)
		auth_url = client.auth_code.authorize_url(
    		:redirect_uri => "urn:ietf:wg:oauth:2.0:oob",
    		:scope =>
        		"https://docs.google.com/feeds/ " +
        		"https://docs.googleusercontent.com/ " +
        		"https://spreadsheets.google.com/feeds/"
        )

		unless credentials['google_refresh_token'].nil?
			auth_token = OAuth2::AccessToken.from_hash(client,
    		{:refresh_token => credentials['google_refresh_token']})
			auth_token = auth_token.refresh!
		else
			# Redirect the user to auth_url and get authorization code from redirect URL.
			print("1. Open this page:\n%s\n\n" % auth_url)
			print("2. Enter the authorization code shown in the page: ")
			authorization_code = $stdin.gets.chomp
			auth_token = client.auth_code.get_token(authorization_code, :redirect_uri => "urn:ietf:wg:oauth:2.0:oob")
			credentials['google_refresh_token'] = auth_token.refresh_token
			File.open(config['credentials'], 'w') do |file|
				file.write credentials.to_yaml
			end
		end
		return auth_token.token
	end
end


#Destructive writing functions live here
module EpicGeo
	module Writers
		module GoogleDrive
			class SheetMaker < GoogleDriveAccess

				attr_reader :sheet, :filename, :toc_row_index, :toc

				def initialize(args)
					super(args) #Call the abstract class to set instance variables
					
					@sheet = session.create_spreadsheet #Make the new sheet
					collection.add(@sheet)				#Add it to the collection
					@filename = args[:name] || Time.now.to_s
					@sheet.title = filename

					create_toc(args[:toc_headers])
				end

				def create_toc(headers)
					@toc = sheet.worksheets[0]
					toc.title="TOC"
					@toc_row_index = 5
					headers ||= ['Handle','Link']
					headers.each_with_index do |header, index|
						toc[toc_row_index,index+1] = header
					end
					@toc_row_index += 1
					toc.save
				end

				def add_worksheet(args) #Must pass a name to the worksheet
					ws_name = args[:title] || Time.now.to_s
					puts "Making new worksheet: #{ws_name}"
					user_sheet = SingleSheet.new( sheet.add_worksheet(ws_name), args[:headers] )
					add_worksheet_to_toc([ws_name, user_sheet.link(ws_name)])
					return user_sheet
				end

				def add_worksheet_to_toc(args)
					args.each_with_index do |column_val, index|
						toc[toc_row_index, index+1] = column_val
					end
					@toc_row_index += 1
					toc.save
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

			# = Handles a Single Sheet within a Workbook
			#
			#This is just a basic wrapper on the google_drive gem to handle custom headers
			class SingleSheet

				attr_reader :ws, :row_index
				
				def initialize(worksheet, headers)
					@ws = worksheet
					@row_index = 1
					write_headers(headers)
				end

				def write_headers(headers)
					headers ||= ["Date", "Geo", "Text"]
					headers.each_with_index do |header, index|
						ws[1, index+1] = header 
					end
					ws.save
				end

				def link(name) #Hardcoded for now, lets fix this later!
					"http://s3.amazonaws.com/epic-twitter-evac/#{name}.html"
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
						#puts e.backtrace
					end
				end

				def save
					ws.save
				end
			end
		end
	end
end