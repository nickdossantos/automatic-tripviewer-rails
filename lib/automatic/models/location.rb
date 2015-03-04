module Automatic
  module Models
    class Location
      def initialize(attributes={})
        @attributes = attributes
      end

      def lon
        @attributes['lon']
      end
      alias :longitude :lon

      def lat
        @attributes['lat']
      end
      alias :latitude :lat

      def accuracy_m
        @attributes['accuracy_m']
      end
    end
  end
end
