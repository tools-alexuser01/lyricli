module Lyricli
  module Util
    def camelize(str)
      str.split('_').map {|w| w.capitalize}.join
    end

    def parse_class(class_name)
      klass = Module.const_get(class_name)
      return klass if klass.is_a?(Class)
      rescue NameError
          return nil
    end
  end
end
