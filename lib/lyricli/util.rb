module Lyricli
  # This module contains several utility functions.
  module Util

    # Transforms a string from snake_case to UpperCamelCase
    #
    # @param [String] str the string that will be Camelized
    # @return [String] the Camelized string.
    def camelize(str)
      str.split('_').map {|w| w.capitalize}.join
    end

    # Takes a class name in snake_case and attempts to find the corresponding
    # class from the sources.
    #
    # @param [String] class_name the snake_case name of the class to search for.
    # @return [Class,nil] the found class or nil
    def parse_class(class_name)
      begin
        path = "Sources::#{class_name}"
        return eval(path)
      rescue NameError
        return nil
      end
    end

    # Simply escapes a param and substitutes spaces and escaped plus signs for
    # plus signs.
    #
    # @param [String] p the parameter to be sanitized
    # @return [String] the sanitized parameter
    def sanitize_param(p)
      CGI.escape(p.gsub(/ /, "+")).gsub("%2B", "+")
    end
  end
end
