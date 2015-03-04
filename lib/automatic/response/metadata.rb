module Automatic
  module Response
    class Metadata

      def initialize(attributes={})
        @attributes = attributes
      end

      def count
        @attributes['count'].to_i
      end

      def next
        @attributes['next']
      end

      def next?
        self.next.present?
      end

      def previous
        @attributes['previous']
      end

      def previous?
        self.previous.present?
      end
    end
  end
end
