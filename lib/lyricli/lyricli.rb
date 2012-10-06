module Lyricli
  class Lyricli

    def initialize
      @source_manager = SourceManager.new
    end

    def exit_with_error
      abort "Usage: #{$0} artist song"
    end

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

    def set_current_track
      @current_track = @source_manager.current_track
    end

    def check_params
      self.exit_with_error if @current_track[:artist].nil? or @current_track[:artist].empty?
      self.exit_with_error if @current_track[:song].nil? or @current_track[:song].empty?
    end
  end
end
