
class EpicGeo
	
	#Require all of the sub modules
	require_relative 'kml/kml_writer'
	require_relative 'geojson/write_geojson_featurecollection'
	require_relative 'html/html_writer'

	def self.hi
		puts "Hello world!"
	end
end