module Assette
  class PostProcessor::CacheBuster < Assette::PostProcessor(:css)
    URL_MATCHER = /url\((?:["'])?(?!http)(?!\/\/)([\w\/\.\-\s\?=]+)(?:["'])?\)/i
  
    def should_process?
      Assette.config.compiling?
    end
  
    def processor
      @@i ||= -1
      
      @str.gsub(URL_MATCHER) do |s|
        url = Assette.compiled_path @@i+=1, $1

        %Q{url("#{url}")}
      end
    end
  
  end
end
