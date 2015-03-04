require File.expand_path('../vehicle', __FILE__)

module Automatic
  module Models
    class Vehicles
      include Enumerable

      def initialize(collection)
        @collection = Array(collection)
      end

      def each(&block)
        record_collection.each(&block)
      end

      private
      def record_collection
        @collection.map { |r| Vehicle.new(r) }
      end
    end
  end
end
