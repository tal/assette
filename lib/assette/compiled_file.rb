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
      c << code_for_dependency(d)
      c << file.comment_str % "End: #{d.path}"
      
      self << c.join("\n")
    end
    
    def post_process file
      str = file.code
      PostProcessor::POST_PROCESSORS[target_class.outputs].each do |processor|
        p = processor.new(file, str, :parent => @file)

        str.replace(p.process)
      end
      
      str
    end
    
    def code_for_dependency d
      post_process(d)
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
      target_class.mime_type
    end
    
    def target_class
      file.target_class
    end

  end
end
