require File.expand_path('../address', __FILE__)
require File.expand_path('../location', __FILE__)

module Automatic
  module Models
    class Trip
      def initialize(attributes={})
        @attributes = attributes
      end

      def id
        @attributes['id']
      end

      def minutes_driven
        (self.duration / 60.0).to_f
      end

      def start_address
        @start_address || Address.new(@attributes.fetch('start_address', {}))
      end

      def end_address
        @end_address || Address.new(@attributes.fetch('end_address', {}))
      end

      def start_location
        @start_location || Location.new(@attributes.fetch('start_location', {}))
      end

      def end_location
        @end_location ||= Location.new(@attributes.fetch('end_location', {}))
      end

      def path
        @attributes['path']
      end

      def duration
        @attributes['duration_s'].to_f
      end

      def hard_brakes
        @attributes['hard_brakes'].to_i
      end

      def hard_brakes?
        self.hard_brakes > 0
      end

      def hard_accels
        @attributes['hard_accels'].to_i
      end

      def hard_accels?
        self.hard_accels > 0
      end

      def minutes_over_70
        (self.duration_over_70_s.to_i/60).ceil
      end

      def minutes_over_70?
        self.minutes_over_70 > 0
      end

      def duration_over_70_s
        @attributes['duration_over_70_s']
      end

      def fuel_cost_usd
        @attributes['fuel_cost_usd']
      end

      def fuel_gallons
        (fuel_volume_l * 0.264172).to_f
      end

      def fuel_cost
        ("%.2f" % [self.fuel_cost_usd]).to_f
      end

      def average_mpg
        val = @attributes['average_kmpl']
        val = (val * 2.35214583)
        ("%.1f" % [val]).to_f
      end

      def start_timezone
        @attributes['start_timezone']
      end

      def started_at
        begin
          DateTime.parse(@attributes['started_at']).in_time_zone(self.start_timezone)
        rescue
          nil
        end
      end

      def end_timezone
        @attributes['end_timezone']
      end

      def ended_at
        begin
          DateTime.parse(@attributes['ended_at']).in_time_zone(self.end_timezone)
        rescue
          nil
        end
      end

      def distance_in_miles
        (distance_m/1609.34).to_f
      end

      private
      def distance_m
        @attributes['distance_m'].to_f
      end

      def fuel_volume_l
        @attributes['fuel_volume_l'].to_f
      end
    end
  end
end
