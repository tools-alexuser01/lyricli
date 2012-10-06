module Lyricli
  module Sources
    class Itunes

      class << self
        attr_accessor :name
      end

      @name = "itunes"

      # The enable method should run all of the tasks needed to validate
      # the source. In the case of Rdio it has to authenticate with OAuth.
      def self.enable
        # Nothing to do
      end

      # Instantiates everything it needs to run.
      def initialize
        @config = Configuration.instance
        @script = "current_song.scpt"
      end

      # The current_track method should return the name of the current
      # artist and song.
      # @return [Hash] A hash containing the current `:song` and `:artist`.
      def current_track
        path_root = File.expand_path(File.dirname(__FILE__))
        path = File.join(path_root, @script)
        current = `osascript #{path}`
        current = current.split("<-SEP->")
        {artist: current[0], song: current[1]}
      end

      # The reset method resets any configurations it may have
      def self.reset
        # Nothing to do
      end
    end
  end
end
