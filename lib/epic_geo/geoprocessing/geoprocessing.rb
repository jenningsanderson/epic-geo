module EpicGeo
	#Geo-Processing Functions
	#
	#This is strictly for processing.  These methods should not make outside calls
	#to models/classes
	module GeoProcessing

		#Algorithm adopted from Andrew Hardin's C# function.
		#Given an array of points, this function will sort the x,y coordinates and
		#return the median point.  This seems to work better than an averaging
		#function because the median point will not geographically consider far outlying
		#points.
		def find_median_point(points_array)
			x = []
			y = []
			points_array.each do |point|
				x << point[0]
				y << point[1]
			end
			x.sort!
			y.sort!
			if (points_array.length % 2).zero?
				mid = x.length/2
				return [ (x[mid]+x[mid-1]) /2.0, (y[mid]+y[mid-1])/2.0]
			else
				mid = x.length/2
				return [x[mid],y[mid]]
			end
		end

		#Casts two two-element arrays to two point objects and returns the distance between them
		def get_distance_from_point_arrays(a1, a2)
			p1 = geofactory.point(a1[0],a1[1])
			p2 = geofactory.point(a2[0],a2[1])

			return p1.distance(p2)
		end


		#Density is defined as 2^(number of tweets) / (area of the tweets)
		#This is an exponential function because it needed more weight on the number of tweets
		def calculate_density(tweets)
			num_tweets = tweets.length
			multi_points = geofactory.multi_point(tweets.collect{|tweet| tweet.point})
			hull = multi_points.convex_hull

			if hull.respond_to? :area
				#It is important to really weight the number of tweets here.
				density = 2**num_tweets / (hull.area)
			else
				density = 0.01 #If no density can be determined, keep it low
			end
			density
		end


		#Find the densest cluster from a cluster of tweets, this could be a home?
		#Should check the timing of this.
		def get_most_dense_cluster(tweet_clusters)
			# puts "Length: #{tweet_clusters.length}"
			most_dense = tweet_clusters[0]
			max_density = 0.0

			tweet_clusters.each do |tweet_cluster|
				density = calculate_density(tweet_cluster)

				#Divide this number by the spread...
				density /= score_temporal_patterns(tweet_cluster)

				if density > max_density
					max_density = density
					most_dense = tweet_cluster
				end
			end
			return most_dense
		end
	end
end
