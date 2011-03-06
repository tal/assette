module Assette
  
  class Template < Assette::File
    def compile
      format = Assette.config.template_format.dup
      
      format.gsub!('{*path*}',local_path.to_json)
      format.gsub!('{*template*}',stringify_body)
    end
    
    def stringify_body
      %Q{"""#{read}"""}
    end
    
    def local_path
      lp = path.gsub(Assette.config.templates_path,'')
      lp.gsub!(/((\.html)?\.\w+)$/,'')
    end
  end
  
end