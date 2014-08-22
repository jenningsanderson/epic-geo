#
# HTML Writer
#
# Writes Twitterer data to an HTML file for easy viewing
#

require_relative 'templates/styles'

class HTML_Writer

	attr_reader :content

	def initialize(filename)
		@filename = filename
		@openfile = File.open(filename, 'wb')
		@content = []
	end

	#Add content as a hash, it just needs a name symbol and a content value
	def add_content(to_add)
		@content << to_add
	end

	def write_header(title)
		@openfile.write %Q{<html>
	<head>
		<title>#{title}</title>
		<style>
		#{write_styles}
		</style>
	</head>
	<body>
}
	end

	def write_styles
		@openfile.write "<style type=\"text/css\">"
		@openfile.write BASIC_STYLES
		@openfile.write "</style>"
	end

	def write_navigation(title)
		@openfile.write %Q{
	<div id="nav_div">
		<h2>#{title}</h2>
		<ul>

}

		@content.each_with_index do |item, index|
			
			@openfile.write %Q{		<li><a href="#item_#{index+1}">#{item[:name]}</a></li>
}
		end

		@openfile.write %Q{	</ul></div>

}
	end

	def write_content

		@openfile.write "\t<ul id=\"content\">\n"

		@content.each_with_index do |content, index|

			@openfile.write %Q{		<li id="item_#{index+1}">
}

			@openfile.write %Q{			<h3 class="name">#{content[:name]}</h3>
}			
			write_table(content[:content])

			@openfile.write "\t\t</li>\n"
			
		end
		@openfile.write "\t</ul>\n"
	end

	def write_table(table_data)

		@openfile.write "\n<table class=\"table_content\">\n"

		@openfile.write "<tr>"
		table_data[0].keys.each do |key|
			@openfile.write "<th>#{key}</th>"
		end
		@openfile.write "</tr>"

		table_data.each_with_index do |hash, index|
			@openfile.write "<tr class=\"table_row_#{index%2}\">\n"
			hash.each do |k,v|
				@openfile.write "<td>#{v}</td>"
			end
			@openfile.write "</tr>\n"
		end
		@openfile.write "</table>\n"
	end

	def close_file
		@openfile.write "</body>\n</html>"
	end

end #end of class