require 'spec_helper'

describe EpicGeo::Container::BoundingBox do

	it "Can successfully parse a GeoJSON file into a bbox geometry" do
		bbox = EpicGeo::Container::BoundingBox.new(geojson: "./test_files/NJ_BoundaryIslands.geojson")
		expect bbox.geometry.area > 100
	end
end