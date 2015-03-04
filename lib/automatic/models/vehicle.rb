require File.expand_path('../trips', __FILE__)

module Automatic
  module Models
    class Vehicle

      def initialize(attributes={})
        @attributes = attributes
      end

      def id
        @attributes['id']
      end

      def url
        @attributes['url']
      end

      def display_name
        @attributes['display_name']
      end

      def color
        (@attributes['color'] || '#999999')
      end

      def make
        @attributes['make']
      end

      def model
        @attributes['model']
      end

      def submodel
        @attributes['submodel']
      end

      def year
        @attributes['year']
      end

      def trips
        @trips ||= Trips.new(@attributes.fetch('trips', []))
      end

      def trips?
        self.trips.any?
      end

      def miles_driven
        self.trips.total_miles_driven.floor
      end

      def minutes_driven
        self.trips.total_minutes_driven
      end

      def fuel_cost
        self.trips.total_fuel_cost
      end

      def fuel_gallons
        self.trips.total_fuel_gallons
      end

      def trips_count
        self.trips.count
      end
    end
  end
end
