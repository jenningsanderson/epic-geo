#
# Object Oriented Programming!
#
# There may just be a way to make Jekyll do this for me, but I'm still thinking through that...
#
#
module EpicGeo
	module Writers
		module HTML
			class WebPage

				attr_reader :filename

				def initialize(filename, parent_directory)
					@filename = filename
					
					@page_path = parent_directory + '/' + filename
					@openfile = File.open(@page_path,'w')
				end

				def write_header(page_name, styles=[], scripts=[])
					@openfile.write (
						%Q{<html>
				<head>
					<title>#{page_name}</title>
					})
					styles.each do |style|
						@openfile.write %Q{<link rel="stylesheet" type="text/css" href="#{style}" /> }
					end

					scripts.each do |script|
						@openfile.write %Q{<script type="text/javascript" src="#{script}"></script>}
					end

					@openfile.write (
						%Q{
				</head>
				<body>} )
				end

				def write_footer
					@openfile.write(
						%Q{
				</body>
				<footer><p>Well, we're trying something very new here</p></footer>
			</html>})

				end


				def add_styles
					return nil
				end

				def write_navigation(dict)
					@openfile.write(
						%Q{
							<ul class=navigation>
							})
					dict.sort_by{|item| item[:name].downcase}.each do |item|
						@openfile.write(
							%Q{
								<li><a href="#{item[:file]}">#{item[:name]}</a></li>
							})
					end
					@openfile.write(
						%Q{
							</ul>
							})
				end

				def add_content(dict)
					dict.each do |k,v|
						unless k == :tweets
							@openfile.write(
								%Q{
									<h5>#{k}: #{v}</h5>
									})
						else #Writing a table to handle the array
							@openfile.write "\n<table class=\"#{k}\">\n"
							@openfile.write "<tr>"
							v[0].keys.each do |key|
								@openfile.write "<th>#{key}</th>"
							end
							@openfile.write "</tr>"

							v.each_with_index do |hash, index|
								@openfile.write "<tr class=\"table_row_#{index%2}\">\n"
								hash.each do |k,v|
									@openfile.write "<td>#{v}</td>"
								end
								@openfile.write "</tr>\n"
							end
							@openfile.write "</table>\n"
						end
					end
				end

				def add_home_button
					@openfile.write '<a id="back_button" href="index.html"><< Back</a>' 
				end

				def write_link(text,href,_class="link")
					@openfile.write %Q{<a class="#{_class}" href="#{href}">#{text}</a>}
				end


				def method_missing(method, *args)
					@openfile.write(
						%Q{
					<#{method}>#{args[0]}</#{method}>})
				end

			end

			class Homepage < WebPage

				def initialize(parent_directory)
					@page_path = parent_directory + '/' + 'index.html'
					@openfile = File.open(@page_path,'w')
				end

			end


			class UserPage < WebPage

				def add_google_earth(link)
					@openfile.write %Q{<script type="text/javascript">
				    	var ge;
				    	google.load("earth", "1", {"other_params":"sensor=false"});

				    	function init() {
				      		google.earth.createInstance('map3d', initCB, failureCB);
				    	}

				    	function getKML(link_in){
							var parent_dir = document.URL.substr(0,document.URL.lastIndexOf('/'))
							return parent_dir + "/" + link_in
				    	}

				    	function initCB(instance) {
				      		ge = instance;
			         		ge.getWindow().setVisibility(true);

			         		ge.getTime().getControl().setVisibility(ge.VISIBILITY_SHOW);

				      		var networkLink = ge.createNetworkLink('');

			        		var link = ge.createLink('');
							var href = getKML("#{link}");

							link.setHref(href);

							networkLink.set(link, true, true); // Sets the link, refreshVisibility, and flyToView

							ge.getFeatures().appendChild(networkLink);


			      		}

			      		function failureCB(errorCode) {
			      		}

			      		google.setOnLoadCallback(init);
			  		</script>

			  		<div id="map3d"></div>}
			  	end
			end
		end
	end
end