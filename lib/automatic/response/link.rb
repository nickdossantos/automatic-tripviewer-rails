module Automatic
  module Response
    class Link
      # Create an instance of a new Link object
      #
      def initialize(attributes={})
        @attributes = attributes
      end

      # Return the URI of the link.
      #
      # @return [String] The uri
      def uri
        @attributes.fetch(:uri, nil)
      end

      # Return the link relationship of the link.
      #
      # @return [String] The link `rel`
      def rel
        @attributes.fetch(:rel, nil)
      end

      # Helper method to see if this is a next? link for pagination
      #
      # @return [Boolean] True if it's a next link
      def next?
        'next' == self.rel
      end

      # Helper method to see if this is a last? link for pagination
      #
      # @return [Boolean] Tru if it's a last Link
      def last?
        'last' == self.rel
      end
      #
      # Helper method to see if this is a first? link for pagination
      #
      # @return [Boolean] Tru if it's a first Link
      def first?
        'first' == self.rel
      end

      # Helper method to see if this is a previous? link for pagination
      #
      # @return [Boolean] True if it's a previous link
      def previous?
        'previous' == self.rel
      end
    end
  end
end
