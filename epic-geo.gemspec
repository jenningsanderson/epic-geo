Gem::Specification.new do |s|
  s.name              = "epic_geo"
  s.version           = '1.1.2'
  s.platform          = Gem::Platform::RUBY
  s.authors           = ["Jennings Anderson"]
  s.email             = ["jennings.anderson@colorado.edu"]
  s.homepage          = "http://github.com/jenningsanderson/epic-geo"
  s.summary           = "A Gem for Handling Geo Data (Predominately Tweets)"
  s.description       = "The Gem is optimized to work with Project EPIC data at University of Colorado Boulder, but I've attempted to write it as general as possible"
  s.rubyforge_project = s.name

  #s.required_rubygems_version = ">= 1.3.6"

  # If you have runtime dependencies, add them here
  # s.add_runtime_dependency "other", "~> 1.2"
  s.add_runtime_dependency "json"
  s.add_runtime_dependency "rgeo" #This is an important dependency to allow the geo calculations


  # The list of files to be contained in the gem
  s.files         = `git ls-files`.split("\n")
  # s.executables   = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  # s.extensions    = `git ls-files ext/extconf.rb`.split("\n")

  s.require_path = 'lib'

  # For C extensions
  # s.extensions = "ext/extconf.rb"
end
