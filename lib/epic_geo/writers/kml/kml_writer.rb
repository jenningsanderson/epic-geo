require 'time'
require 'georuby'
require 'geo_ruby/kml' #Allows writing of georuby geometry objects to kml format

#TODO: The geometry should come in as geojson, I want to do away with all external dependencies
#      except for explicit calculations with rgeo.

#Require the helper functions for writing the styles to the KML file
require_relative 'kml_style_helper'

class KMLAuthor
  
  attr_reader :filename, :openfile
  
  def initialize(filename)
    @filename = filename.dup #Getting weird frozen error...
    unless @filename =~ /\.kml$/
      @filename << '.kml'
    end
    @openfile = File.open(@filename, 'w')
  end

  #Write the KML header information and give the the file a name
  def write_header(title)
    @openfile.write %Q{<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2">
<Document>
  <name>
    #{title}
  </name>
  }
  end

  #The main workhorse -- a beautiful recursive function (if I may say so) to write folders to the document
  def write_folder(folder)
    @openfile.write "<Folder>\n<name>#{folder[:name]}</name>\n"

    unless folder[:folders].nil?
      folder[:folders].each do |inner_folder|
        write_folder(inner_folder)
      end
    end#else
    
    unless folder[:features].empty?
      folder[:features].each do |feature|
        write_placemark(feature)
      end
  #  end
    end
    @openfile.write "</Folder>\n\n"
  end

  #Each placemark can be thought of as a feature in a geojson collection, there are many options, certainly not 
  def write_placemark(feature)
    @openfile.write "<Placemark>\n"
    unless feature[:name].nil?
      @openfile.write "\t<name>#{feature[:name]}</name>\n"
    end
    if feature.has_key? :style
      @openfile.write "\t<styleUrl>#{feature[:style]}</styleUrl>\n"
    end
    if feature.has_key? :extended
      @openfile.write "\t<ExtendedData>\n"
      feature[:extended].each do |k,v|
        @openfile.write "\t\t<Data name=\"#{k}\">#{v}</Data>\n"
      end
      @openfile.write "\t</ExtendedData>\n"
    end
    if feature.has_key? :desc
      if feature.has_key? :link
        @openfile.write "\t<description>\n\t\t#{feature[:desc]}\n<![CDATA[<img src=\"#{feature[:link]}\">]]></description>\n"
      else
      @openfile.write "\t<description>\n\t\t#{feature[:desc]}\n\t</description>\n"
      end
    end
    if feature.has_key? :time
      @openfile.write "\t<TimeStamp>\n"
      @openfile.write "\t\t<when>#{feature[:time].iso8601}</when>\n"
      @openfile.write "\t</TimeStamp>"
    end
    if feature.has_key? :gxTrack
      @openfile.write %Q{\t<gx:Track>
      \t\t<altitudeMode>absolute</altitudeMode>
      \t\t<when>#{feature[:gxTrack][:start][:time].iso8601}</when>
      \t\t<when>#{feature[:gxTrack][:end][:time].iso8601}</when>
      \t\t<gx:coord>#{feature[:gxTrack][:start][:pos]}</gx:coord>
      \t\t<gx:coord>#{feature[:gxTrack][:end][:pos]}</gx:coord>
      \t</gx:Track>}
    end

    unless feature[:geometry].nil?
      @openfile.write "\t"+feature[:geometry].as_kml #What type of geometry do we need here?
    end
    @openfile.write "</Placemark>\n\n"
  end

  #Properly close the kml file
  def write_footer
    @openfile.write("\n</Document>\n</kml>")
  end

end
