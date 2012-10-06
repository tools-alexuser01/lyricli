module Lyricli
  module Exceptions
    # There is an error with the source's configuration and it can't
    # find its current track.
    class SourceConfigurationError < StandardError
    end
  end
end

