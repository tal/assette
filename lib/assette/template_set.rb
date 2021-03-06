module Assette
  #shitty
  def preloader_file
    p = Assette.config.template_preloader
    pp = Assette.config.find_file_from_relative_path(p) if p
    Assette::File.open(pp) if pp
  end
  
  #shitty
  def preloader_code
    pp = preloader_file
    pp.all_code if pp
  end
  
  class TemplateSet
    attr_reader :templates
    
    def initialize *location
      if location.size == 1
        location = location.pop
      end
      
      if location.is_a?(Array)
        location = 'all' if location.include?(:all) || location.include?('all')
      else
        location = location.to_s
      end
      
      path = Assette.config.templates_path
      
      if location == 'all'
        dirs = [File.join(path,'*')]
      elsif location.is_a?(Array)
        dirs = location.collect do |l|
          File.join(path,l)
        end
      else
        dirs = [File.join(path,location)]
      end
      
      @paths = []
      dirs.each do |dir|
        @paths += Dir[File.join(dir,'*')]
      end
      
      @templates = @paths.collect do |p|
        Template.open(p)
      end
    end
    
    def compile(opts={})
      coffee = Array.new
      
      vars = storage_variable
      
      used = []
      vars.each do |var|
        used << var
        
        if used.size == 1
          str = "window[#{var.to_json}] ||= {}"
        else
          str = used.join('.')
          str << " ||= {}"
        end
        
        coffee << str
      end
      
      templates.each do |template|
        coffee << template.compile
      end
      
      t = Assette::Reader::Coffee.compile_str(coffee.join("\n"))
      pre = Assette.preloader_code unless opts[:no_preloader]
      pre ? [pre,t].join("\n") : t
    end
    
    def storage_variable
      format = Assette.config.template_format
      if m = format.match(/^([\w\.]+)\[/)
        vars = m[1].split('.')
      else
        []
      end
    end
    
  end
  
end