
class EpicGeo
	
	#Require all of the features that don't have external dependencies
	require_relative 'kml/kml_writer'
	require_relative 'geojson/write_geojson_featurecollection'

	def self.hi
		puts "Hello world!"
	end

	def initialize
		require_relative('geojson/write_geojson_featurecollection.rb')
	end

	def shapefile
		require_relative('shapefile')
	end
end