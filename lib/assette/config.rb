require 'yaml'

module Assette
  def config(optional_path=nil)
    return @config if @config && !optional_path
    
    f = %w{assets.yml config/assets.yml}
    f.unshift(optional_path.to_s) if optional_path
    f << File.join( File.dirname(__FILE__), '..', '..', 'examples', 'defaults.yml' )

    p = f.find { |path| File.exist?(path) }
    
    @config = Assette::Config.load(p)
  end
  
  class Config
    OPTIONS = [
      :file_paths, :asset_path, :templates_path, :template_format
    ]
    attr_reader *OPTIONS
    
    def initialize args = {}
      args.each do |k,v|
        instance_variable_set "@#{k}", v.dup.freeze
      end
    end
    
    class << self
      
      def load p
        new YAML.load_file(p)
      end
      
    end
    
  end
  
end
