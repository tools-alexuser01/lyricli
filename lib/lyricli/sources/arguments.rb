module Lyricli
  module Sources
    # The arguments source. This one is special since it expects two
    # arguments. It is treated specially by the SourceManager.
    class Arguments

      class << self
        attr_accessor :name
      end

      @name = "arguments"

      # The enable method should run all of the tasks needed to validate
      # the source. In the case of Rdio it has to authenticate with OAuth.
      def self.enable
        # Nothing to do.
      end

      # Instantiates everything it needs to run.
      def initialize
        # Nothing to do.
      end

      # The current_track method should return the name of the current
      # artist and song.
      # @return [Hash] A hash containing the current `:song` and `:artist`.
      def current_track
        artist = ARGV[0]
        song = ARGV[1]
        {:artist => artist, :song => song}
      end

      # The reset method resets any configurations it may have
      def self.reset
        # Reset Code
      end
    end
  end
end
