module Assette
  class CompiledFile < Array
    attr_reader :file

    def initialize(file)
      @file = file
    end

    def add_dependency d
      c = []
      c << "\n"
      c << file.comment_str % "Start: #{d.path}"
      c << d.code
      c << file.comment_str % "End: #{d.path}"
      self << c.join("\n")
    end

    def content_type
      return mime_type.content_type if mime_type

      case file.target_class.outputs
      when :js
        'text/javascript'
      when :css
        'text/css'
      else
        'text/plain'
      end
    end

    def mime_type
      file.target_class.mime_type
    end

  end
end
