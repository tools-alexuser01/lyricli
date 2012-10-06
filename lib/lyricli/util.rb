module Lyricli
  module Util
    def camelize(str)
      str.split('_').map {|w| w.capitalize}.join
    end

    def parse_class(class_name)
      begin
        path = "Sources::#{class_name}"
        return eval(path)
      rescue NameError
        return nil
      end
    end

    def sanitize_param(p)
      URI.encode_www_form_component(p.gsub(/ /, "+")).gsub("%2B", "+")
    end
  end
end
