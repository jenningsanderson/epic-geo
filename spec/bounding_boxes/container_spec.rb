require 'spec_helper'

describe EpicGeo::Container::BoundingBox do
	it "Can successfully parse a GeoJSON file into a bbox geometry" do
		
		bbox = EpicGeo::Container::BoundingBox.new(geojson: "/Users/jenningsanderson/Documents/Twitter-Evacutation-Patterns/GeoJSON/NJ_BoundaryIslands.geojson")

		expect bbox.geometry.area > 0
	end

	xit "Can parse a point and check for intersections" do 
			
	end
end