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

      "console.error(#{str.to_json});alert(#{str.inspect.to_json});"
    end
    
    def comment_str
      '// %s'
    end
    
    def tag path
      <<-HTML
        <script src="#{path}" type="text/javascript"></script>
      HTML
    end

    def include path
      # <<-JS
      #   (function() {
      #     var e = document.createElement('script'); e.async = false;
      #     e.src = '#{path}?nodep';
      #     document.getElementsByTagName('head')[0].appendChild(e);
      #   }());
      # JS
      <<-JS
        document.write("<script src='#{path}?nodep'></script>")
      JS
    end
  end
end
