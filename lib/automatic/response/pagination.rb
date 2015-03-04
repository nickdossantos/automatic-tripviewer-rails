module Automatic
  module Response
    class Pagination
      def initialize(attributes={})
        @attributes = attributes
      end

      def page
        @attributes[:page].to_i
      end
      alias :current_page :page

      def per_page
        @attributes[:per_page].to_i
      end

      def total_pages
        (self.total_entries / self.per_page)
      end

      def total_entries
        @attributes[:total_entries].to_i
      end
    end
  end
end
