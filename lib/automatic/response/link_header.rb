require File.expand_path('../links.rb', __FILE__)

module Automatic
  module Response
    class LinkHeader
      InvalidLinkHeaderError = Class.new(StandardError)

      # Parses the Link header and then returns an instance of Links wrapper
      #
      def initialize(header=nil)
        @header       = header.to_s
        @link_records = []
      end

      # Returns a collection of links parsed from the String
      #
      # @return [Array, Links] A Links array Wrapper
      def links
        return @links if @links

        extract!

        @links ||= Automatic::Response::Links.new(@link_records)
      end

      # Returns true if there are Links in the wrapper
      #
      # @return [Boolean] Returns true if there are any links
      def links?
        self.links.any?
      end

      private
      def extract!
        if @header
          parts = @header.split(',')

          parts.each do |part|
            section = part.split(';')

            raise InvalidLinkHeaderError.new('Invalid Link Header') if section.size != 2

            url  = section[0].gsub(/<(.*)>/, '\1').strip
            rel  = section[1].gsub(/rel="(.*)"/, '\1').strip

            @link_records << { uri: url, rel: rel }
          end
        end

        @link_records
      end
    end
  end
end
