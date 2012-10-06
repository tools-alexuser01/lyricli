module Lyricli

  # This class has the basic logic for extracting the lyrics and controlling the
  # application
  class Lyricli

    # Constructor, initializes `@source_manager`
    def initialize
      @source_manager = SourceManager.new
    end

    # Raises an InvalidLyricsException which means we did not get any valid
    # artist/song from any of the sources
    #
    # @raise [Lyricli::InvalidLyricsException] because we found nothing
    def exit_with_error
      raise InvalidLyricsException
    end

    # Extracts the current track, validates it and requests the lyrics from our
    # LyricsEngine
    #
    # @return [String] the found lyrics, or a string indicating none were found
    def get_lyrics
      set_current_track
      check_params

      engine = LyricsEngine.new(@current_track[:artist], @current_track[:song])

      begin
        engine.get_lyrics
      rescue LyricsNotFoundException
        "Lyrics not found :("
      end
    end

    # Set the `@current_track` instance variable by asking the SourceManager for
    # its current track
    def set_current_track
      @current_track = @source_manager.current_track
    end

    # Exits with error when there is an empty field from the current track.
    def check_params
      self.exit_with_error if @current_track[:artist].nil? or @current_track[:artist].empty?
      self.exit_with_error if @current_track[:song].nil? or @current_track[:song].empty?
    end
  end
end
