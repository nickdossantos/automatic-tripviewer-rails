module Automatic
  module Models
    class Address

      def initialize(attributes={})
        @attributes = attributes
      end

      def name
        @attributes['name']
      end

      def short_name
        "%s %s, %s, %s" % [self.street_number, self.street_name, self.city, self.state]
      end

      def display_name
        @attributes['display_name']
      end

      def street_number
        @attributes['street_number']
      end

      def street_name
        @attributes['street_name']
      end

      def state
        @attributes['state']
      end

      def city
        @attributes['city']
      end

      def country
        @attributes['country']
      end
    end
  end
end
