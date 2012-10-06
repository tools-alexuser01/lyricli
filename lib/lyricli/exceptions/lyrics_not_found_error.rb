module Lyricli
  module Exceptions
    # No lyrics could be found for this artist/song pair
    class LyricsNotFoundError < StandardError
    end
  end
end

