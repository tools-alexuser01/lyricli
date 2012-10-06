module Lyricli

  # Manages the different sources. SourceManager is in charge of enabling and
  # disabling them, as well as getting the current track.
  class SourceManager

    include Util

    # Creates a new instance of SourceManager
    def initialize
      @enabled_sources = []
      @config = Configuration.instance
      @config["enabled_sources"].each do |source|
        if klass = parse_class(camelize(source))
          current_source = klass.new
          @enabled_sources << current_source
        else
          raise Exceptions::StartSourceError
        end
      end
    end

    # Enables a source. This runs the source's enable method and adds it to the
    # `enabled_sources` configuration key. It will only enable sources that
    # are "available" (see #available_sources)
    #
    # @param [String] source_name the name of the source to enable
    def enable(source_name)
      if available_sources.include?(source_name)
        if klass = parse_class(camelize(source_name))
          klass.enable
          @config["enabled_sources"] << klass.name
          @config["enabled_sources"].uniq!
          @config.save_config
        else
          raise Exceptions::EnableSourceError
        end
      else
        raise Exceptions::UnknownSourceError
      end
    end

    # Disables a source. This only removes the source from the `enabled_sources`
    # configuration key.
    #
    # @param [String] source_name the name of the source to disable
    def disable(source_name)
      if available_sources.include?(source_name)
        if klass = parse_class(camelize(source_name))
          @config["enabled_sources"].delete(klass.name)
          @config.save_config
        else
          raise Exceptions::DisableSourceError
        end
      else
        raise Exceptions::UnknownSourceError
      end
    end

    # Resets a source. This runs the source's reset method. It will also disable
    # them.
    #
    # @param [String] source_name the name of the source to reset.
    def reset(source_name)
      if available_sources.include?(source_name)
        if klass = parse_class(camelize(source_name))
          klass.reset
          disable(source_name)
        else
          raise Exceptions::ResetSourceError
        end
      else
        raise Exceptions::UnknownSourceError
      end
    end

    # Iterates over every source to attempt to retrieve the current song.
    #
    # @return [Hash] the current track, has an `:artist` and `:song` key.
    def current_track
      track = nil
      lock = false
      @enabled_sources.each do |source|
        begin
          current_track = source.current_track

          # This is a special thing for arguments. The thing is, they need to
          # be inputted manually. So, if they are present they won't allow
          # anyone else to give results. Makes sense, yet a bit hacky.
          unless current_track[:artist].nil? || current_track[:artist].empty? || current_track[:song].nil? || current_track[:song].empty?
            track = current_track unless lock
            lock = true if source.class.name == "arguments"
          end
        rescue
          raise Exceptions::SourceConfigurationError
        end
      end
      track
    end

    # Returns an array with the available sources. Optionally formats the result
    # so active sources are identified by an appended *
    #
    # @param [Boolean] format whether or not to render the stars for active
    #                         sources.
    # @return [Array] the names of the currently available sources.
    def available_sources(format = false)
      path_root = File.expand_path(File.dirname(__FILE__))
      sources = Dir[path_root+"/sources/*.rb"].map{ |s|
        name = s.split("/").last.gsub(/\.rb/, "")
        name
      }

      # Remove arguments (Hack?) We don't want anybody to touch tihs one.
      sources.delete("arguments")
      if format
        # Add a star to denote enabled sources
        format_sources(sources)
      else
        sources
      end
    end

    # Adds a star to all members of the array that correspond to an active
    # source
    #
    # @param [Array] sources the array of sources to format
    # @return [Array] the formatted array
    def format_sources(sources)
      sources.map{ |s|
        s << "*" if @config["enabled_sources"].include?(s)
        s
      }
    end
  end
end
