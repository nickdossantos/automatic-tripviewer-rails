module Automatic
  module Utilities
    class DurationCalculator
      # This takes seconds as arguments and can then
      # break down the necessary durations and output.
      def initialize(seconds)
        @seconds = seconds
      end

      def days
        parsed[0]
      end

      def days?
        self.days > 0
      end

      def hours
        parsed[1]
      end

      def hours?
        self.hours > 0
      end

      def minutes
        parsed[2]
      end

      def minutes?
        self.minutes > 0
      end

      def seconds
        parsed[3]
      end

      def seconds?
        self.seconds > 0
      end

      private
      def parsed
        return @parsed if @parsed
        days,hours,minutes,seconds = [60,60,24].reduce([@seconds]) { |m,o| m.unshift(m.shift.divmod(o)).flatten }

        @parsed = [days, hours, minutes, seconds]
        @parsed
      end

      def step_parsed
        return @parsed if @parsed
        minutes, seonds = @seconds.divmod(60)
        hours, minutes  = minutes.divmod(60)
        days, hours     = hours.divmod(24)

        @parsed = [days, hours, minutes, seconds]
        @parsed
      end
    end
  end
end
