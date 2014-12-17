#These are the basic, basic requirements
require 'rgeo'
require 'rgeo-geojson'

#Add the right parts to the build path
$:.unshift File.dirname(__FILE__)+'/epic_geo'

#=EpicGeo
#
#When included, this module requires all
module EpicGeo

	#TODO
	#A default factory should be defined here that can be easily over-ridden
	
	#I want, nay, I need specific geo functions for tweets and twitterers.
	require 'twitter_geo'

	#The GeoProcessing Module
	require 'geoprocessing/geoprocessing'

	#Clustering
	require 'geoprocessing/db_scan'
	require 'geoprocessing/k-means'

	#Containers
	require 'bounding_boxes/container'

	#Writers
	#I'd rather perform a lazy load for these, but I don't know how to handle these? -- handle these later?
	require 'writers/geojson/write_geojson_featurecollection'

	#This will throw an error if google_drive gem is not available, this should be done via lazy loading
	require 'writers/google_drive/google_sheets'

	require 'writers/html/archive_maker'

	require 'writers/kml/kml_writer'
end