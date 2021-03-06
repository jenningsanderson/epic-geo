module EpicGeo

	#Holds all geo-spatial clustering methods, specifically tuned to tweets,
	#but any objects which respond to @#point@ should work.
	module Clustering

		#DB Scan
		#
		#First Modified by Jennings Anderson July 31, 2014
		#
		#Modified to allow Tweets to maintain in their original form
		#
		#Original Header:
		####################################################
		# shiguodong, June 2011
		# References:
		# 1. see also wikipedia entry (this implementation is similar to
		#    their pseudo code): http://en.wikipedia.org/wiki/DBSCAN
		####################################################

		class DBScan

			attr_reader :distance_hash, :tweets, :epsilon, :min_pts

			def initialize(tweets, epsilon=0.05, min_pts=2)

				@tweets,@epsilon,@min_pts = tweets,epsilon,min_pts

				print "building distance matrix for #{tweets.count} tweets..."
				build_distance_matrix
				puts "done"
			end

			def run
				_dbscan
			end

			def _dbscan
				clusters = {}
				clusters[-1] = []
				current_cluster = -1
				for point in tweets
					if not point.visited
						point.visited = true
						neighbours = immediate_neighbours(point)
						if neighbours.size >= min_pts
							current_cluster += 1
							point.cluster = current_cluster
							cluster = [point,]
							cluster.push(add_connected(neighbours,current_cluster))
							clusters[current_cluster] = cluster.flatten
						else
							clusters[-1].push(point)
						end
					end
				end
				return clusters
			end

			def immediate_neighbours(point)
				neighbours = []
				tweets.each do |p|
					next	if p == point
					neighbours << p if distance_hash[[point.id,p.id]] < epsilon
				end
				return neighbours
			end

			def add_connected(neighbours,current_cluster)
				cluster_points = []
				neighbours.each do  |point|
					if not point.visited
						point.visited = true
						new_points = immediate_neighbours(point)
						new_points.each do |p|
							if  not (neighbours.include? p)
								neighbours.push(p)
							end
						end  if new_points.size >= min_pts
					end

					if !point.cluster
						cluster_points.push(point)
						point.cluster = current_cluster
					end
				end
				return cluster_points
			end

			#=Perform all of the distance calculations in n^2 / 2 time, then just look them up
			#
			def build_distance_matrix
				@distance_hash = {}
				tweets.each_with_index do |tweet_i, idx|
					tweets[idx+1..-1].each do |tweet_j|
						d = tweet_i.point.distance(tweet_j.point)
						@distance_hash[ [tweet_i.id, tweet_j.id] ] = d
						@distance_hash[ [tweet_j.id, tweet_i.id] ] = d
					end
				end
			end
		end
	end
end
