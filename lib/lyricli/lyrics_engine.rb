module Lyricli

  # This class gets the lyrics according to a given artist and song name.
  class LyricsEngine

    include Util

    # Starts a new instance of LyricsEngine
    #
    # @param [String] artist the artist
    # @param [String] song the song to look for
    def initialize(artist, song)
      @provider = URI("http://lyrics.wikia.com/api.php?artist=#{sanitize_param artist}&song=#{sanitize_param song}&fmt=realjson")
    end

    # Asks Lyrics Wiki for the lyrics, also cleans up the output a little.
    #
    # @return [String] the lyrics
    def get_lyrics
      begin
        response = Net::HTTP.get(@provider)
        response = MultiJson.decode(response)

        doc = Nokogiri::HTML(open(response['url']))
        node = doc.search(".lyricbox").first
      rescue
        raise Exceptions::LyricsNotFoundError
      end

      node.search(".rtMatcher").each do |n|
        n.remove
      end

      node.search("script").each do |n|
        n.remove
      end

      node.search("br").each do |br|
        br.replace "\n"
      end

      node.inner_text.gsub(/\s+$/, "")
    end
  end
end
