require 'yaml'

module Assette
  attr_accessor :config
  
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

f = %w{assets.yml config/assets.yml}
f << File.join( File.dirname(__FILE__), '..', '..', 'examples', 'defaults.yml' )

p = f.find { |path| File.exist?(path) }

Assette.config = Assette::Config.load(p)
