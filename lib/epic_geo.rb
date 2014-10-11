
#These are the basic, basic requirements
require 'rgeo'
require 'rgeo-geojson'

#Other Requirements (will be called lazily eventually)
#google_drive
#yaml

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


	#Writers
	#I'd rather perform a lazy load for these, but I don't know how to handle these? -- handle these later?
	require_relative  'epic_geo/writers/geojson/write_geojson_featurecollection'

	#This will throw an error if google_drive gem is not available, this should be done via lazy loading
	require_relative  'epic_geo/writers/google_drive/google_sheets'

	require_relative  'epic_geo/writers/html/archive_maker'

	require_relative  'epic_geo/writers/kml/kml_writer'
end