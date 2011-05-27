class Assette::File < ::File
  extend Forwardable
  
  def text
    @text || (dependencies && @text)
  end
  
  def extension
    m = filename.match(/\.(\w+)$/)
    m[1] if m
  end
  
  def reader_class
    if klass = Assette::Reader::ALL[extension]
      klass
    else
      raise "Can't find reader class Assette::Reader::#{extension.capitalize}"
    end
  end
  
  def target_class
    return @target_class if @target_class
    ex = reader_class.outputs
    
    raise(Exception, "Define @outputs for #{reader_class.class}") unless ex
    
    if @target_class = Assette::Reader::ALL[ex.to_s]
      @target_class
    else
      raise "Can't find reader class Assette::Reader::#{ex.capitalize}"
    end
  end
  
  def mime_type
    @mime_type ||= MIME::Types.type_for(path).first
  end
  
  def comment_str(str = nil)
    comm = target_class.comment_str
    str ? (comm % str) : comm
  end
  
  def code
    reader_class.new(self).compile
  rescue => e
    target_class.error(e.to_s,path)
  end
  
  def template_set
    Assette::TemplateSet.new(templates)
  end
  
  def all_code_array
    dep = Assette::CompiledFile.new(self)
    
    if !templates.empty?
      dep << template_set.compile
    end
    
    dependencies.each {|d| dep.add_dependency(d)}
    
    dep.add_dependency(self)
    
    dep
  end
  
  def all_code
    all_code_array.join("\n")
  end
  
  def dirname
    File.dirname(path)
  end
  
  def target_path
    File.expand_path(File.join(dirname,filename.gsub(reader_class.extension,target_class.extension)))
  end
  
  def relative_target_path
    tp = target_path
    Assette.config.file_paths.each do |fp|
      f = File.expand_path(fp)
      tp.gsub! f, ''
    end
    tp
  end
  
  def filename
    File.basename(path)
  end
  
  def puts *args
    STDOUT.puts *args
  end
  
  def == other
    if other.instance_of?(self.class)
      other.path == path
    else
      super
    end
  end
  
  def read
    @read ||= super
  end
  
  def dependencies
    return @dependencies if @dependencies
    
    @dependencies = []
    
    read_config do |l|
      m = l.match /@require(?:s)?\s+([\w\.\/-]+)/
      next unless m
      
      p = ::File.expand_path(::File.join(dirname,m[1]))
      
      Assette.logger.info("Dependecy Checking") {p}
      
      # Check for _filename if filename doesn't exist
      unless ::File.exist?(p)
        p2 = p.gsub /(.*\/)?(.+)/, '\1_\2'
        Assette.logger.info("Dependecy Checking") {p2}
        if ::File.exist?(p2)
          p = p2
        else
          raise "Cannot find dependancy #{p} or #{p2} as required in #{path}"
        end
      end
      
      f = Assette::File.open(p)
      
      @dependencies << f
      f.dependencies.each do |d|
        @dependencies << d unless @dependencies.include?(d)
      end
      
    end
    
    Assette.logger.debug('Dependencies') {"For: #{path}\n#{@dependencies.pretty_inspect}"}
    
    @dependencies
  end
  
  def templates
    return @templates if @templates
    
    @templates = []
    
    read_config do |line|
      m = line.match /@template(?:s)?\s+(\w+)/
      next unless m
      
      @templates << m[1]
    end
    
    dependencies.each do |dep|
      dep.templates.each do |template|
        @templates << template unless @templates.include?(template)
      end
    end
    
    @templates
  end
  
  def read_config
    started = nil
    @text = read
    @text.each_line do |l|
      next unless started ||= (l =~ /#{Assette::CONFIG_WRAPPER}/)
      break if l =~ /\/#{Assette::CONFIG_WRAPPER}/
      
      yield(l)
    end
  end
  
  def path_array
    code = []
    
    code << "/__templates/#{templates.join(':')}" unless templates.empty?
    
    code += dependencies.collect do |d|
      d.relative_target_path
    end
    
    code << relative_target_path
  end
  
  class << self
    
    def all_code_for *args
      start = Time.now
      f = open(*args)
      code = f.all_code
      code << "\n"
      code << f.comment_str % "Time taken to generate: #{Time.now-start}s"
    end
    
    # This code is aweful. gotta fix it
    #shitty
    def rack_resp_if_exists path, opts = {}
      return unless File.exist?(path)
      start = Time.now
      f = open(path)
      
      if opts[:deparr]
        code = f.path_array
        
        resp = {:dependencies => code, :target_type => f.target_class.mime_type, :target_extension => f.extension}
        
        resp[:generation_time] = Time.now-start
        
        return [200,{"Content-Type" => 'text/javascript'}, [resp.to_json]]
      end
      
      if opts[:nodep]
        code = [f.code]
        type = f.target_class.mime_type
      else
        code = f.all_code_array
        type = f.target_class.mime_type
      end
      
      code << "\n"
      code << f.comment_str % "Time taken to generate: #{Time.now-start}s"
      
      [200,{"Content-Type" => type.content_type},code]
    end
    
  end
  
end
