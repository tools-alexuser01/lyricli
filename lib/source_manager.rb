module Lyricli
  class SourceManager

    include Lyricli::Util

    def initialize
      @enabled_sources = []
      @config = Lyricli::Config
    end

    def enable(source_name)
      if source_module = module_exists?(camelize(str))
        source_module.enable
        @config[:enabled_sources] << klass.name
      else
        raise Lyricli::EnableSourceException
      end
    end

    def disable(source_name)
      if source_module = module_exists?(camelize(str))
        @config[:enabled_sources].delete(klass.name)
      else
        raise Lyricli::DisableSourceException
      end
    end

    def reset(source_name)
      if source_module = module_exists?(camelize(str))
        source_module.reset
        disable(source_name)
      else
        raise Lyricli::ResetSourceException
      end
    end

    def start
      @config[:enabled_sources].each do |source|
        begin
          source.start
        rescue
          fail "Source #{source.name} has failed to start. Please reset the source by running `#{$0} source reset #{source.name}.`"
        end
      end
    end
  end
end
