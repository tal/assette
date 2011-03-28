class Assette::PostProcessor::CacheBuster < Assette::PostProcessor(:css)
  URL_MATCHER = /url\((?:["'])?(?!http)(?!\/\/)([\w\/\.\-\s\?=]+)(?:["'])?\)/i
  
  def should_process?
    Assette.config.compiling?
  end
  
  def processor
    @@i ||= -1
    
    @str.gsub(URL_MATCHER) do |s|
      url = File.join(Assette.config.asset_host(@@i+=1),Assette.config.compiled_path($1))
      
      %Q{url("#{url}")}
    end
  end
  
end
