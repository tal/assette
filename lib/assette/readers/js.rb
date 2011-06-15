class Assette::Reader::Js < Assette::Reader(:js)
  
  def compile
    @file.text
  end
  
  class << self
    
    def error str, path=nil
      if path
        <<-JS
        console.group("Compiling Error in file #{path}");
        console.error(#{str.to_json});
        console.groupEnd();
        JS
      else
        "console.error(#{str.to_json});"
      end
    end
    
    def comment_str
      '// %s'
    end
    
    def tag path
      <<-HTML
        <script src="#{path}" type="text/javascript"></script>
      HTML
    end
  end
end
