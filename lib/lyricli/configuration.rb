module Lyricli

  # This class handles the configuration of Lyricli
  class Configuration

    # Defines the paths to the default and user configuration files
    def initialize
      @config_path = "~/.lyricli.conf"
      @defaults_path = "defaults.json"
      @config = nil
    end

    @@instance = Configuration.new

    # Ensure this is only called once. Only use the instance class variable
    # to access this method, as its constructor is private.
    def self.instance
      @@instance
    end

    # Access configuration properties, loads config if needed beforehand.
    #
    # @param [String] key the configuration key to access
    # @return [String, Hash, Array] the value of the configuration key.
    def [](key)
      load_config unless @config
      @config[key]
    end

    # Assigns a new value to a configuration key, loads config if needed and
    # saves it after updating.
    #
    # @param [String] key the configuration key to set
    # @param [Object] value the value for the configuration key, can be any
    #                 object as long as it can be converted to JSON
    def []=(key, value)
      load_config unless @config
      @config[key] = value
      save_config
    end

    # Deletes a key from the configuration, loads config if needed and saves
    # it after deleting.
    #
    # @param [String] key the key to delete
    def delete(key)
      load_config unless @config
      @config.delete(key)
      save_config
    end

    private_class_method :new

    # Loads the configuration from the user file, attempts to create it from
    # defaults if it's not present. sets the `@config` instance variable.
    def load_config
      path = File.expand_path(@config_path)

      if File.exists?(path)
        file = File.new(path, "r")
        @config = MultiJson.decode(file.read)
      else
        load_default_config
      end
    end

    # Serializes the `@config` Hash to JSON and saves it to a file.
    def save_config
      path = File.expand_path(@config_path)
      file = File.new(path, "w")
      file.print(MultiJson.encode(@config))
      file.close
    end

    private

    # Loads the default configuration from a JSON file
    def load_default_config
      # Load the default
      path = File.join(::Lyricli.root, "config", @defaults_path)

      if File.exists?(path)
        file = File.new(path, "r")
        @config = MultiJson.decode(file.read)
      else
        @config = {}
      end
    end
  end
end
