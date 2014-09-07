#
# HTML Archive maker
#
# Writes Twitterer Data to a directory, which can then be published to an s3
# bucket, if desired.  Designed for better visualizations of full contextual streams.
#

require 'fileutils'

require_relative 'templates/styles'
require_relative 'page_models'

class HTMLArchiveMaker

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

	def add_user_page(user, contents)
		this_file = UserPage.new(user+'.html', @dir_path)
		
		@dir_contents << {:name=>user, :file=>this_file.filename}
		
		this_file.write_header(user)
		this_file.add_home_button
		this_file.h1 user

		this_file.add_content(contents)

		this_file.write_footer
	end

	def write_index
		index = Homepage.new(@dir_path)
		index.write_header("Users to Code")
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