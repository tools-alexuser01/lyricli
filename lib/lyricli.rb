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

# Local Dependencies
require "lyricli/util"
require "lyricli/configuration"
require "lyricli/lyricli"
require "lyricli/lyrics_engine"
require "lyricli/source_manager"
require "lyricli/sources/arguments"
require "lyricli/sources/rdio"
require "lyricli/sources/itunes"

# The Lyricli module allows you to easily search for lyrics by looking for
# song and artist data from diverse sources.
module Lyricli
  # Creates a new Lyricli instance and returns lyrics by going through the
  # sources.
  # @return [String] the fetched lyrics
  def self.lyrics
    @lyricli = Lyricli.new
    @lyricli.get_lyrics
  end

  def self.version
    Gem.loaded_specs["lyricli"].version
  end

  def self.sources
    source_manager = SourceManager.new
    source_manager.available_sources.join(", ")
  end

  def self.enable

  end

  def self.disable

  end

  def self.reset

  end
end
