require File.expand_path('../link.rb', __FILE__)

module Automatic
  module Response
    class Links
      include Enumerable

      def initialize(collection)
        @collection = Array(collection)
      end

      def each(&block)
        links_collection.each(&block)
      end

      def previous
        self.select(&:previous?).first
      end

      def previous?
        !!self.previous
      end

      def next
        self.select(&:next?).first
      end

      def next?
        !!self.next
      end

      def last_page
        self.select(&:last?).first
      end

      def last_page?
        !!self.last_page
      end

      def first_page
        self.select(&:first?).first
      end

      def first_page?
        !!self.first_page
      end

      private
      def links_collection
        @collection.map { |record| Link.new(record) }
      end
    end
  end
end
