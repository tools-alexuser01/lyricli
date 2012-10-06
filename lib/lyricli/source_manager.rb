module Lyricli
  class SourceManager

    include Util

    def initialize
      @enabled_sources = []
      @config = Configuration.instance
      @config["enabled_sources"].each do |source|
        if klass = parse_class(camelize(source))
          current_source = klass.new
          @enabled_sources << current_source
        else
          raise StartSourceException
        end
      end
    end

    def enable(source_name)
      if klass = parse_class(camelize(source_name))
        klass.enable
        @config["enabled_sources"] << klass.name
        @config["enabled_sources"].uniq!
      else
        raise EnableSourceException
      end
    end

    def disable(source_name)
      if klass = parse_class(camelize(source_name))
        @config["enabled_sources"].delete(klass.name)
      else
        raise DisableSourceException
      end
    end

    def reset(source_name)
      if klass = parse_class(camelize(source_name))
        klass.reset
        disable(source_name)
      else
        raise ResetSourceException
      end
    end

    def current_track
      track = nil
      @enabled_sources.each do |source|
        begin
          track ||= source.current_track
        rescue
          fail "Source #{source.name} has failed to start. Please reset the source by running `#{$0} source reset #{source.name}.`"
        end
      end
      track
    end

    def available_sources
      path_root = File.expand_path(File.dirname(__FILE__))
      sources = Dir[path_root+"/sources/*"].map{ |s|
        s.split("/").last.gsub(/\.rb/, "")
      }

      # Remove arguments (Hack?) We don't want anybody to touch tihs one.
      sources.delete("arguments")
      sources
    end
  end
end
