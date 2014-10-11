#
# HTML Archive maker
#
# Writes Twitterer Data to a directory, which can then be published to an s3
# bucket, if desired.  Designed for better visualizations of full contextual streams.
#

module EpicGeo
	module Writers
		module HTML
			
			class ArchiveMaker
				require 'fileutils'

				require_relative 'templates/styles'
				require_relative 'page_models'

				#Initialize an Archive with a path and a name.
				def initialize(dir_name, dir_path='./')
					@directory_name = dir_name
					@dir_path = dir_path+dir_name
					@css_path = @dir_path+'/css'

					unless Dir.exists? @dir_path
						Dir.mkdir @dir_path 
					end

					unless Dir.exists? @css_path
						Dir.mkdir @css_path
					end

					#This will be an array of hashes for the nav table:
					# => [{:name=> name, :file=>filename.html},..]
					@dir_contents = []
				end

				def add_user_page(user, contents, kml=nil)
					this_file = EpicGeo::Writers::HTML::UserPage.new(user+'.html', @dir_path)
					
					@dir_contents << {:name=>user, :file=>this_file.filename}
					
					if kml
						kml_scripts=["https://www.google.com/jsapi"]
					end
					this_file.write_header(
						user, 
						styles=["css/styles.css"], 
						scripts=kml_scripts
					)
					this_file.add_home_button
					this_file.h1 user
					unless kml.nil?
						this_file.write_link("KML File", kml)
						this_file.add_google_earth(kml)
					end

					this_file.add_content(contents)

					this_file.write_footer
				end

				def write_index
					index = EpicGeo::Writers::HTML::Homepage.new(@dir_path)
					index.write_header("Users to Code", styles=["css/styles.css"], scripts=[])
					index.h1 "Users to Code"
					index.p "The full contextual streams for these users along with small interactive maps of their storm migration activities is available under the links to the left."

					index.write_navigation(@dir_contents)

					index.write_footer
				end

				def add_style(style="styles.css")
					src = File.dirname(__FILE__) + "/templates/css/styles.css"
					FileUtils.cp(src, @css_path)
				end
			end
		end
	end
end