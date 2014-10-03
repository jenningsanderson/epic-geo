#This will be killed soon (or should be):
require 'georuby'
require 'rgeo'

module EpicGeo

	# The only dependency of this module is for the Twitterer to have a collection of tweets
	module GeoTwitterer

		# --------------------- GeoSpatial General Functions ------------------------#
		# Create an rgeo points array for all of a user's tweets
		def points
			@points ||= tweets.collect{ |tweet| tweet.point } #tweet.point returns an Rgeo point for the tweet
		end

		# Return Just the points as a multi_point geo object
		def user_points
			factory.multi_point(points)
		end

		# Create LineString of points
		def user_path
			@userpath = factory.line_string(points)
		end




		# ------------------------- GeoJSON Functions -----------------------------#
		# Create a geojson linestring
		def full_user_path_json
			points = tweets.collect{ |tweet| tweet.coordinates["coordinates"]}
			return {:type => "LineString", :coordinates => points}
		end


		def full_median_point_json
			median_point = find_median_point tweets.collect do |tweet|
				tweet.coordinates["coordinates"]
			end

			return {:type => "Point", :coordinates => median_point}
		end


		def point_to_geojson_hash(point, features=nil)
			unless features.nil?
				return {:type=>"Feature",
				:properties => features,
				:geometry=>{:type=>"Point", :coordinates=>point}}
			else
				return {:type=>"Point", :coordinates=>point}
			end
		end


		def points_to_geojson_linestring(points, features=nil)
			unless features.nil?
				return {:type=>"Feature",
				:properties => features,
				:geometry=>{:type=>"LineString", :coordinates=>points}}
			else
				return {:type=>"LineString", :coordinates=>points}
			end
		end

		#TODO: Fix this
		def critical_points_to_json_hash
			geojson_hash = {:type=>"FeatureCollection", :features=>[]}

			if shelter_location == cluster_locations[:before_home]
				geojson_hash[:features] << point_to_geojson_hash( shelter_location, {:Place=> "Shelter-In-Place Location"} )
			else
				geojson_hash[:features] << point_to_geojson_hash( cluster_locations[:before_home], {:Place=> "Before Home"} )
				geojson_hash[:features] << point_to_geojson_hash( shelter_location, {:Place=> "Most Likely Shelter Location"} )
			end

			#Build the linestring from their cluster_pattern
			#Get each cluster location by day (Only in the wanted window)
			cluster_path = []
			clusters_per_day.sort_by{|day,clusters| day.to_i}.each do |day, cluster_ids|
				unless day.to_i < 300 or day.to_i > 314
					cluster_ids.each do |cluster_id|
						cluster_path << cluster_locations[cluster_id]
					end
				end
			end

			geojson_hash[:features] << points_to_geojson_linestring(cluster_path, {:desc=>"User Path: Oct 28 - Nov 9"})

			return geojson_hash.to_json
		end


		def tweets_to_geojson(_start=nil, _end=nil)
			geojson_hash = {:type=>"FeatureCollection", :features=>[]}

			tweets.each do |tweet|
				if _start.nil?
					geojson_hash[:features] << tweet.as_geojson
				else
					if tweet.date > _start and tweet.date < _end
						geojson_hash[:features] << tweet.as_geojson
					end
				end
			end

			return geojson_hash.to_json
		end


		def individual_points_json
			points = tweets.collect{ |tweet| tweet.coordinates["coordinates"]}
			return {:type => "MultiPoint", :coordinates => points}
		end


		#Return a geojson Feature Collection of Individual Tweets
		def individual_tweets_json
			features = []
			tweets.each do |tweet|
				features << {:type => "Feature",
										 :geometry=> tweet["coordinates"],
										 :properties => {
												:text => tweet["text"],
												:created_at => tweet["date"],
												:handle => tweet["handle"].join(',')
											}}
			end
			return {:type => "FeatureCollection", :features => features}
		end



		# --------------------- KML Functions -------------------------#

		def userpath_as_epic_kml
			linestring = GeoRuby::SimpleFeatures::LineString.from_coordinates(
				tweets.collect{|tweet| tweet.coordinates["coordinates"]} )

			{:name 			=> handle,
			 :geometry => linestring,
			}
		end

	end





	#Make a Tweet Geo-aware!
	module GeoTweet
		
		#Used for DBScan Clustering
  		attr_accessor :cluster, :visited

		def point
    		@point ||= FACTORY.point(
    			coordinates["coordinates"][0],
    			coordinates["coordinates"][1])
  		end

 		#To write the tweet to a kml file from epic-geo,
  		# it must be formatted as follows:
		# def as_epic_kml(style=nil)
		# {:time     => @date,
		#  :style    => style,
		#  :geometry => GeoRuby::SimpleFeatures::Point.from_x_y(
		#    @coordinates["coordinates"][0],
		#    @coordinates["coordinates"][1] ),
		#  :name     => nil, #Setting name to nil because otherwise it's hard to see
		#  :desc     =>
		#  %Q{#{@handle}<br />
		#     #{@text}<br />
		#     #{@date}}
		# }
		# end

  		#Return this tweet as valid GeoJSON
  		def as_geojson
    		{ 	type: "Feature",
     		 	properties: { 	time: 	date,
            		       		text: 	text,
                    	   		handle: handle
                    	   	 },
     		 	geometry: coordinates
     		 }
  		end

  			# A helper function to convert a point to epic-KML
		def point_as_epic_kml(name, x, y, style=nil)
			{ 	name:  name,
				style: style,
		  		geometry: GeoRuby::SimpleFeatures::Point.from_coordinates([x,y]) 
		  	 }
		end
	end
end