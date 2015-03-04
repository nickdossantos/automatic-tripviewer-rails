require File.expand_path('../trip', __FILE__)

module Automatic
  module Models
    class Trips
      include Enumerable

      def initialize(collection)
        @collection = Array(collection)
      end

      def each(&block)
        record_collection.each(&block)
      end

      def total_miles_driven
        self.inject(0) { |accum,record| accum += record.distance_in_miles; accum }
      end

      def total_minutes_driven
        self.inject(0) { |accum,record| accum += record.minutes_driven; accum }
      end

      private
      def record_collection
        @collection.map { |r| Trip.new(r) }
      end
    end
  end
end
