#
# EpicGeo extension to create containers and bounding boxes
# => 
#
#

require 'rgeo'
require 'rgeo-geojson'

module EpicGeo
	module Container

		class Container #Can I inherit geo methods here, or is that poor form?

			attr_reader :factory

			def initialize(args)
				@name = args[:name]
				post_initialize(args)

				factory = FACTORY # => I don't like this, but we'll use it for now.
			end
		end

		class BoundingBox < Container

			attr_reader :geojson, :geometry, :features, :factory

			def initialize(args)
				@geojson = args[:geojson]

				@factory = RGeo::Geographic.simple_mercator_factory #Perhaps we'll use a smarter factory in a bit
				super(args)
			end

			def post_initialize(args)

				if geojson
					load_geojson(geojson)
				end
			end
			
			def load_geojson(geojson_file)
				geo_json = File.read(geojson_file)
				@features = RGeo::GeoJSON.decode(geo_json, json_parser: :json)

				@geometry=factory.parse_wkt(features.first.geometry.to_s)
			end
		end
	end
end
