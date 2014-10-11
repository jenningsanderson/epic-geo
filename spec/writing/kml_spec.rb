require "spec_helper"

include EpicGeo::Writers::KML

describe KMLAuthor do
	before :each do
		@testfile = KMLAuthor.new('kmltestfile')
	end

	after :each do
	 	File.delete('kmltestfile.kml')
	end
	
	it "successfully names it appropriately" do
      expect @testfile.filename == 'kmltestfile.kml'
  end

	it "successfully Opens file" do
		expect(File).to exist('kmltestfile.kml')
	end

	it "can write a color ramp" do
		num_styles = 10
		write_color_ramp_style(@testfile.openfile, num_styles)
		@testfile.openfile.close
		styles = File.open("kmltestfile.kml", "rb").read.scan(/<Style id="c_ramp_style_(\d)"/)
		expect styles.collect{|id| id[0].to_i} == (0..num_styles-1).to_a.reverse
	end

	it "can write a random color scheme" do
		num_styles = 10
		generate_random_styles(@testfile.openfile, num_styles)
		@testfile.openfile.close
		
		styles = File.open("kmltestfile.kml", "rb").read.scan(/<Style id="r_style_(\d)"/)
		expect styles.collect{|id| id[0].to_i} == (0..num_styles-1).to_a
	end
end