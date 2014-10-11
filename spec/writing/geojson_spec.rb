require "spec_helper"

include EpicGeo::Writers

describe GeoJSONWriter do
	before :each do
		@testfile = GeoJSONWriter.new('geojsontestfile')
		@test_hash = {:properties => {:name => 'test'}}
	end

	after :each do
	 	File.delete('geojsontestfile.geojson')
	end
	
	it "Successfully names it appropriately" do
    	expect @testfile.filename == 'geojsontestfile.geojson'
  	end

  	it "Successfully creates file" do
  		expect(File).to exist('geojsontestfile.geojson')
  	end
end