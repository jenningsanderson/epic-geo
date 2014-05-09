require "spec_helper"

describe KMLAuthor do
	before :all do
		@testfile = KMLAuthor.new('testfile')
	end

	after :all do
	 	File.delete('testfile.kml')
	end
	
	it "Successfully names it appropriately" do
    	@testfile.filename.should == 'testfile.kml'
  	end

  	it "Successfully Opens file" do
  		expect(File).to exist('testfile.kml')
  	end
end