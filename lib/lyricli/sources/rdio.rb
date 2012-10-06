module Lyricli
  module Sources
    class Rdio

      class << self
        attr_accessor :name
      end

      @name = "rdio"

      # The enable method should run all of the tasks needed to validate
      # the source. In the case of Rdio it has to authenticate with OAuth.
      def self.enable
        # Validation Code
        @config = Lyricli::Configuration.instance
        unless @config["rdio_auth_token"] && !@config["rdio_auth_token"].empty?
          create_auth_token
        end

      end

      # Instantiates everything it needs to run.
      def initialize
        @name = 'rdio'
        @config = Lyricli::Configuration.instance
        @rdio = Rdio::SimpleRdio.new([@config["rdio_key"], @config["rdio_secret"]], @config["rdio_auth_token"])
      end

      # The current_track method should return the name of the current
      # artist and song.
      # @return [Hash] A hash containing the current `:song` and `:artist`.
      def current_track
        response = @rdio.call('currentUser', {'extras' => 'lastSongPlayed'})
        artist = response["result"]["lastSongPlayed"]["artist"]
        song = response["result"]["lastSongPlayed"]["name"]
        {artist: artist, song: song}
      end

      # The reset method resets any configurations it may have
      def self.reset
        # Reset Code
      end

      # Signs in to rdio with our credentials and requests access for a new auth
      # token.
      def self.create_auth_token
        @rdio = Rdio::SimpleRdio.new([@config["rdio_key"], @config["rdio_secret"]], @config["rdio_auth_token"])

        # Request Authorization
        puts "Follow this URL to authorize lyricli:"
        auth_url = rdio.begin_authentication('oob')
        puts auth_url
        Launchy.open(auth_url)

        # Request Code, Obtain Token
        print "Please type the authorization code: "
        auth_code = gets.chomp
        token = rdio.complete_authentication(auth_code)

        @config["rdio_auth_token"] = token
        token
      end

    end
  end
end
