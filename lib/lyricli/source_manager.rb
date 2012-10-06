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
      if available_sources.include?(source_name)
        if klass = parse_class(camelize(source_name))
          klass.enable
          @config["enabled_sources"] << klass.name
          @config["enabled_sources"].uniq!
          @config.save_config
        else
          raise EnableSourceException
        end
      else
        raise UnknownSource
      end
    end

    def disable(source_name)
      if available_sources.include?(source_name)
        if klass = parse_class(camelize(source_name))
          @config["enabled_sources"].delete(klass.name)
          @config.save_config
        else
          raise DisableSourceException
        end
      else
        raise UnknownSource
      end
    end

    def reset(source_name)
      if available_sources.include?(source_name)
        if klass = parse_class(camelize(source_name))
          klass.reset
          disable(source_name)
        else
          raise ResetSourceException
        end
      else
        raise UnknownSource
      end
    end

    def current_track
      track = nil
      @enabled_sources.each do |source|
        begin
          current_track = source.current_track

          unless current_track[:artist].nil? || current_track[:artist].empty? || current_track[:song].nil? || current_track[:song].empty?
            track = current_track
          end
        rescue
          raise SourceConfigurationException
        end
      end
      track
    end

    def available_sources(format = false)
      path_root = File.expand_path(File.dirname(__FILE__))
      sources = Dir[path_root+"/sources/*"].map{ |s|
        name = s.split("/").last.gsub(/\.rb/, "")

        # Add a star to denote enabled sources
        name
      }

      # Remove arguments (Hack?) We don't want anybody to touch tihs one.
      sources.delete("arguments")
      if format
        format_sources(sources)
      else
        sources
      end
    end

    def format_sources(sources)
      sources.map{ |s|
        s << "*" if @config["enabled_sources"].include?(s)
        s
      }
    end
  end
end
