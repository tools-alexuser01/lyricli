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

  # Returns the version of the library
  # @return [String] the version
  def self.version
    Gem.loaded_specs["lyricli"].version
  end

  # Returns a list of the available sources to enable or disable
  def self.sources
    source_manager = SourceManager.new
    source_manager.available_sources(true).join(", ")
  end

  def self.enable(source_name)
    source_manager = SourceManager.new
    source_manager.enable(source_name)
  end

  def self.disable(source_name)
    source_manager = SourceManager.new
    source_manager.disable(source_name)
  end

  def self.reset(source_name)
    source_manager = SourceManager.new
    source_manager.reset(source_name)
  end
end
