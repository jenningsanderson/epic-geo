require 'rgeo'

module EpicGeo

	#Need to do some testing with this....

	#TODO
	#A default factory should be defined here that can be easily over-ridden
	
	#I want, nay, I need specific geo functions for tweets and twitterers.
	require_relative 'epic_geo/twitter_geo'

	#The GeoProcessing Module
	require_relative 'epic_geo/geoprocessing/geoprocessing'

	#Clustering
	require_relative 'epic_geo/geoprocessing/db_scan'
	require_relative 'epic_geo/geoprocessing/k-means'


	#Containers
	require_relative 'epic_geo/bounding_boxes/container'


	#I'd rather perform a lazy load for these, but I don't know how to handle these?
	#Writers -- handle these later?
	#autoload :GeoJSONWriter,          'epic_geo/writers/geojson/write_geojson_featurecollection
end