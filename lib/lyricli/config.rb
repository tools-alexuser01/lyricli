module Lyricli
  class Config

    def initialize
      @config_path = "~/.lyricli.conf"
      @config = load_config
    end

    @@instance = Config.new

    def self.instance
      @@instance
    end

    def [](key)
      @config[key]
    end

    def []=(key, value)
      @config[key] = value
      save_config
    end

    private_class_method :new

    private

    # TODO: Apart from this, load a default yml that will be used for this.
    # And just extend everything from the user's config.
    def load_config
      path = File.expand_path(@config_path)
      if File.exists?(path)
        file = File.new(path, "r")
        MultiJson.decode(file.read)
      else
        {}
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
