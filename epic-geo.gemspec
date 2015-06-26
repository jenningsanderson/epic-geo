Gem::Specification.new do |s|
  s.name              = "epic_geo"
  s.version           = '1.1.4'
  s.platform          = Gem::Platform::RUBY
  s.authors           = ["Jennings Anderson"]
  s.email             = ["jennings.anderson@colorado.edu"]
  s.homepage          = "http://github.com/jenningsanderson/epic-geo"
  s.summary           = "A Gem for Handling Geo Data (Predominately Tweets)"
  s.description       = "The Gem is optimized to work with Project EPIC data at University of Colorado Boulder, but I've attempted to write it as general as possible"
  s.rubyforge_project = s.name
  s.license           = "MIT"

  s.add_runtime_dependency "json", "~> 1.8"
  s.add_runtime_dependency "rgeo", "~> 0.3.20"

  # The list of files to be contained in the gem
  s.files         = `git ls-files`.split("\n")
  # s.executables   = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  # s.extensions    = `git ls-files ext/extconf.rb`.split("\n")

  s.require_path = 'lib'

  # For C extensions
  # s.extensions = "ext/extconf.rb"
end
