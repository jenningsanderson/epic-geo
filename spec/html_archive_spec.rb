require "spec_helper"

describe HTMLArchiveMaker do
	before :all do
		@test_dir = HTMLArchiveMaker.new('test_dir')
    @test_dir.add_style
	end

  it "Works" do 
    attrs = {:score=>1.0, :tweets=>[{:date=>"nope", :text=>"yup"},{:date=>"nope2", :text=>"yup2"},{:date=>"nope3", :text=>"yup3"}]}
    @test_dir.add_user_page("Jennings", attrs)
    @test_dir.write_index
  end
end