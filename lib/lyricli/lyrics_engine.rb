module Lyricli
  class LyricsEngine

    include Util

    def initialize(artist, song)
      @provider = URI("http://lyrics.wikia.com/api.php?artist=#{sanitize_param artist}&song=#{sanitize_param song}&fmt=realjson")
    end

    def get_lyrics
      begin
        response = Net::HTTP.get(@provider)
        response = MultiJson.decode(response)

        doc = Nokogiri::HTML(open(response['url']))
        node = doc.search(".lyricbox").first
      rescue
        raise Lyricli::LyricsNotFoundException
      end

      node.search(".rtMatcher").each do |n|
        n.remove
      end

      node.search("br").each do |br|
        br.replace "\n"
      end

      node.inner_text
    end

  end
end
