module Assette
  # Methods for finding files are ugly, should fix someday
  class Server
    attr_reader :path
    def initialize(path)
      @path = path
      Assette.config.asset_path
    end
    
    def find_compiled_file
      f = nil
      Assette.config.file_paths.each do |p|
        
        Assette::Reader.possible_targets(File.join(p,path)).each do |pp|
          f = Assette::File.rack_resp_if_exists( pp )
          break if f
        end
        
        break if f
      end
      f
    end
    
    def path_extension
      m = path.match(/\.(\w+)$/)
      m[1] if m
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
          f = File.open(new_path)
          # add in grabbing index.html files if no extension provided
        end
        
        break if f
      end
      
      f
    end
    
    def rack_resp
      
      if has_registered_reader? && (f = find_compiled_file)
        [200,{"Content-Type" => f.content_type},f]
      elsif (f = find_file) && path_mime_type
        puts content_type
        [200,{"Content-Type" => content_type},f]
      else
        [404,{"Content-Type" => "text/plain"},["File Not Found"]]
      end
    end
    
    class << self
      
      def call(env)
        s = new(env["PATH_INFO"])
        
        s.rack_resp
      # rescue => e
      #   [500,{"Content-Type" => "text/plain"},[e.inspect]]
      end
      
    end
    
  end
  
end
