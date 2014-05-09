require "spec_helper"

describe KMLAuthor do
	before :each do
		@testfile = KMLAuthor.new('kmltestfile')
	end

	after :each do
	 	File.delete('kmltestfile.kml')
	end
	
	it "successfully names it appropriately" do
    	@testfile.filename.should == 'kmltestfile.kml'
  	end

  	it "successfully Opens file" do
  		expect(File).to exist('kmltestfile.kml')
  	end

  	it "can write random styles" do
  		write_color_ramp_style(@testfile.openfile, 9)
  		@testfile.openfile.close
  		styles = File.open("kmltestfile.kml", "rb").read.scan('<Style')
  		styles.count.should eq(9)

  	end
end