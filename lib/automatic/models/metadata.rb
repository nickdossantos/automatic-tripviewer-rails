module Automatic
  module Models
    class Metadata

      def initialize(attributes={})
        @attributes = attributes
      end

      def count
        @attributes['count'].to_i
      end
    end
  end
end
