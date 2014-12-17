'''
Write a geojson feature collection
'''

module EpicGeo
  
  module Writers

    class GeoJSONWriter

      require 'json'
      attr_reader :filename, :extension

      def initialize(args)
        @filename = args[:filename]
        @extension = args[:extension] || "geojson"
       
        @open_file = File.open("#{filename}.#{extension}", 'w')
      end

      def add_options(options_array)
        @options = options_array
      end

      def write_header
        @open_file.write "{\"type\" : \"FeatureCollection\","
        unless @options.nil?
          @options.each do |option|
            opt_string = option.to_json.to_s
            @open_file.write opt_string[1..-2]
            @open_file.write(',')
          end
        end
        @open_file.write "\"features\" :["
      end

      def write_feature(geometry, properties)
        unless geometry.is_a? Hash
          geometry = RGeo::GeoJSON.encode(geometry)
        end
        @open_file.write "{"
        @open_file.write "\"type\" : \"Feature\", "
        @open_file.write "\"geometry\" : #{geometry.to_json},"
        @open_file.write "\"properties\" : #{properties.to_json}"
        @open_file.write "},"
      end

      def literal_write_feature(feature)
        @open_file.write(feature)
        @open_file.write(",")
      end

      def write_footer
        #Close the file and then truncate the last comma
        @open_file.close()
        File.truncate("#{filename}.#{extension}", File.size("#{filename}.#{extension}") - 1) #Remove the last comma

        #Open the file again and close the object
        File.open("#{filename}.#{extension}",'a') do |file|
          file.write(']}')
        end
      end
    end #end class
  end
end
