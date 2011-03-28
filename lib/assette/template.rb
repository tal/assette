module Assette
  
  class Template < Assette::File
    def compile
      if Assette.config.template_partial && filename =~ /^_/
        format = Assette.config.template_partial.dup
      else
        format = Assette.config.template_format.dup
      end
      
      format.gsub!('{*path*}',local_path.to_json)
      format.gsub!('{*template*}',stringify_body)
    end
    
    def stringify_body
      %Q{"""#{read}"""}
    end
    
    def local_path
      lp = path.gsub(Assette.config.templates_path,'')
      lp.gsub!(/((\.html)?\.\w+)$/,'').gsub!(/^\//,'')
      lp.gsub!(/\/_/,'/')
      lp
    end
  end
  
end