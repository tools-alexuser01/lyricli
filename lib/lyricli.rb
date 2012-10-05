#!/usr/bin/env ruby -w

require 'uri'
require 'net/http'
require 'multi_json'
require 'nokogiri'
require 'open-uri'
require 'launchy'

# This shit causes a lot of warnings. Quick Hack.
original_verbosity = $VERBOSE
$VERBOSE = nil
require 'rdio'
$VERBOSE = original_verbosity

class Lyricli

  # TODO: Change the whole fucking thing
  def initialize
    @rdio_key = "sddac5t8akqrzh5b6kg53jfm"
    @rdio_secret = "PRcB8TggFr"
    @token_path = File.expand_path("~/.rdio_token")

    #Expand the symlink and get the path
    if File.symlink?(__FILE__) then
      path = File.dirname(File.readlink(__FILE__))
    else
      path = File.dirname(__FILE__)
    end

    # Get the current rdio track
    @rdio = init_rdio
    rdio_track

    #Get the current iTunes track
    current = `osascript #{path}/current_song.scpt`
    if current and not current.empty? then
      current = current.split("<-SEP->")
      @artist ||= current[0]
      @song ||= current[1]
    end
  end

  def init_rdio

    if File.exists?(@token_path)
      f = File.new(@token_path, "r")
      begin
        token = MultiJson.decode(f.read)
      rescue
        token = create_rdio_token
      end
    else
      token = create_rdio_token
    end

    Rdio::SimpleRdio.new([@rdio_key, @rdio_secret], token)
  end


  def exit_with_error
    abort "Usage: #{$0} artist song"
  end

  def get_lyrics

    #Use the API to search
    uri = URI("http://lyrics.wikia.com/api.php?artist=#{self.sanitize_param @artist}&song=#{self.sanitize_param @song}&fmt=realjson")
    begin
      res = Net::HTTP.get(uri)
      res = MultiJson.decode(res)

      #Get the actual lyrics url
      doc = Nokogiri::HTML(open(res['url']))
      node = doc.search(".lyricbox").first
    rescue
      abort "Lyrics not found :("
    end

    #Remove the rtMatcher nodes
    node.search(".rtMatcher").each do |n|
      n.remove
    end

    #Maintain new lines
    node.search("br").each do |br|
      br.replace "\n"
    end

    #Retrieve the lyrics
    puts node.inner_text
  end

  def check_params
    self.exit_with_error if @artist.nil? or @artist.empty?
    self.exit_with_error if @song.nil? or @song.empty?
  end

  def sanitize_param(p)
    URI.encode_www_form_component(p.gsub(/ /, "+")).gsub("%2B", "+")
  end
end


lrc = Lyricli.new
lrc.check_params
lrc.get_lyrics
