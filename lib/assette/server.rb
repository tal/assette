module Assette
  # Methods for finding files are ugly, should fix someday
  class Server
    attr_reader :path
    def initialize(env)
      @env = env
      @path = env["PATH_INFO"]
      
      @params = env["QUERY_STRING"].split('&').inject({}) do |resp,v|
        k,v = v.split('=')
        
        if v == '1' || v.nil?
          v = true
        elsif v == '0'
          v = false
        end
        
        resp[k.to_sym] = v
        resp
      end
      
      # Assette.config.asset_path
    end
    
    def find_compiled_file
      f = nil
      Assette.config.file_paths.each do |p|
        
        Assette::Reader.possible_targets(File.join(p,path)).each do |pp|
          Assette.logger.debug('Checking for compiled file') {pp}
          f = Assette::File.rack_resp_if_exists( pp, @params.merge(:env => @env) )
          Assette.logger.info("Found File") {"Compiled file at #{pp}"} if f
          break if f
        end
        
        break if f
      end
      
      f
    end
    
    def path_extension
      m = path.match(/\.(\w+)$/)
      m ? m[1] : :none
    end
    
    def has_registered_reader?
      !Assette::Reader::OUTPUTS[path_extension.to_sym].empty?
    end
    
    def path_mime_type
      @path_mime_type ||= MIME::Types.type_for(path).first
    end
    
    def content_type
      path_mime_type ? path_mime_type.content_type : 'text/plain'
    end
    
    def find_file
      f = nil
      
      Assette.config.file_paths.each do |p|
        new_path = File.join(p,path)
        if File.exist?(new_path)
          new_path = File.join(Dir.pwd,new_path)
          Assette.logger.info("Found File") {"Raw file at #{new_path}"}
          f = Rack::File.new(p).call(@env)
        end
        
        break if f
      end
      
      f
    end
    
    def looking_for_template?
      m = path.match(/__templates\/(.+)/)
      m[1].gsub(/.js$/,'').split(':') if m
    end
    
    def rack_resp
      if templates = looking_for_template?
        set = TemplateSet.new(templates)
        return [200,{"Content-Type" => Reader::Js.mime_type.content_type},[set.compile]]
      end
      
      if has_registered_reader? && (f = find_compiled_file)
        f
      elsif f = find_file
        f
      else
        possible_paths = Assette.config.file_paths.collect do |p|
          File.join(Dir.pwd,p,path)
        end
        
        [404,{"Content-Type" => "text/plain"},["File Not Found\n#{possible_paths.join("\n")}"]]
      end
    end
    
    class << self
      
      def call(env)
        s = new(env)
        
        s.rack_resp
      end
      
    end
    
  end
  
end
