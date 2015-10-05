require 'rgeo'

module EpicGeo

	def coords_as_geojson(coords)
		{type: "Point", coordinates: coords}
	end


	# The main this module is for the Twitterer to have a collection of tweet
	#  objects which include ::GeoTweet
	#
	# A global variable $factory, should be set with the desired factory for the
	# 	dataset.
	#
	module GeoTwitterer

		# --------------------- GeoSpatial General Functions ------------------------#
		# Create an rgeo points array for all of a user's tweets
		def points
			@points ||= tweets.collect{ |tweet| tweet.point } #tweet.point returns an Rgeo point for the tweet
		end

		# Return Just the points as a multi_point geo object
		def user_points
			$factory.multi_point(points)
		end

		# Create LineString of points
		def user_path
			@userpath = $factory.line_string(points)
		end

		def coords_as_point(coordinates)
			$factory.point(coordinates[0],coordinates[1])
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

		def cluster_locations_as_geojson
			feat = {type: "FeatureCollection", properties: {user: handle}, features: []}
			# puts clusters
			clusters.each do |cluster_id, tweets|
				feat[:features] << {
					type: "Feature",
					properties: {
						id: cluster_id,
						tweets: tweets.count
					},
					geometry: {type: "Point", coordinates: cluster_locations[cluster_id]}
				}
			end
			return feat
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


		def tweets_to_geojson(_start=nil, _end=nil, with_line=false)
			geojson_hash = {:type=>"FeatureCollection", :features=>[]}

			tweets.each_with_index do |tweet,idx|
				if _start.nil?
					geojson_hash[:features] << tweet.as_geojson
				else
					if tweet.date > _start and tweet.date < _end

						geojson_hash[:features] << tweet.as_geojson

						if with_line and !tweets[idx+1].nil?
							geojson_hash[:features] << {
								type: "Feature",
								properties: {},
								geometry:{
									type: "LineString",
									coordinates: [tweet.coordinates, tweets[idx+1].coordinates]
								}
							}
						end
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
	end


	#Make a Tweet Geo-aware!
	module GeoTweet

  	#Get the coordinates of the tweet as an rgeo point object
		def point
    	@point ||= $factory.point(
    		coordinates[0],
    		coordinates[1])
  	end

		#Return the tweet as a hash in valid geojson for storing as a complete feature in a GeoJSON file.
		def as_geojson
			{:type=>"Feature", :properties=>{:time=>local_date.iso8601, :text=>text, :cluster => cluster_id}, :geometry=>{type: "Point", coordinates: coordinates}}
		end
	end
end
