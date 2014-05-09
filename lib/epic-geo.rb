'''
Depending on how this is instantiated, it should call different dependencies.

'''

#First require all of the features that don't have external dependencies
require_relative 'kml/kml_writer'

class EpicGeo
  def self.hi
    puts "Hello world!"
  end

  def initialize()
    require_relative('geojson/write_geojson_featurecollection.rb')
  end

  def shapefile()
    require_relative('shapefile')
  end
end
