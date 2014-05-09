'''
Depending on how this is instantiated, it should call different dependencies.

'''
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
