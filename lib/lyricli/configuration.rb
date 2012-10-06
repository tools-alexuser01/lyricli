module Lyricli
  class Configuration

    def initialize
      @config_path = "~/.lyricli.conf"
      @defaults_path = "defaults.json"
      @config = nil
    end

    @@instance = Configuration.new

    def self.instance
      @@instance
    end

    def [](key)
      load_config unless @config
      @config[key]
    end

    def []=(key, value)
      load_config unless @config
      @config[key] = value
      save_config
    end

    private_class_method :new

    private

    # TODO: Apart from this, load a default yml that will be used for this.
    # And just extend everything from the user's config.
    def load_config
      # path = File.expand_path(@config_path)
      path_root = File.expand_path(File.dirname(__FILE__))
      path = File.join(path_root, @defaults_path)

      if File.exists?(path)
        file = File.new(path, "r")
        @config = MultiJson.decode(file.read)
      else
        @config = {}
      end
    end

    def save_config
      path = File.expand_path(@config_path)
      file = File.new(path, "w")
      file.print(MultiJson.encode(@config))
      file.close
    end
  end
end
