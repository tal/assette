module Assette
  def config(optional_path=nil)
    return @config if @config && !optional_path
    
    f = %w{assets.rb config/assets.rb}
    f.unshift(optional_path.to_s) if optional_path

    p = f.find { |path| File.exist?(path) }
    raise "Can't find config file" unless p
    @config = Assette::Config.load(p)
  end
  
  def compiled_path i, path
    File.join(Assette.config.asset_host(i),Assette.config.compiled_path(path))
  end
  
  class Config
    MULTIPLES = %w{file_path asset_host}.freeze
    SINGLES = %w{asset_dir templates_path template_format cache_method 
      template_preloader template_partial asset_version_file uglifier
      minify}.freeze
    BLOCKS = %w{after_compile}.freeze
    
    OPTIONS = begin
      arr = MULTIPLES.collect do |m|
        "#{m}s"
      end
      arr += SINGLES
      arr += BLOCKS
    end.freeze
    
    attr_reader *OPTIONS
    attr_accessor :compiling, :sha
    attr_writer :env
    
    DEFAULTS = {
      :asset_dir => 'assets',
      :asset_version_file => 'assets/version',
      :asset_hosts => [],
      :file_paths => %w{public},
      :templates_path => 'app/templates',
      :template_format => 'AT.t[{*path*}] = {*template*};',
      :after_compile => Proc.new {},
      :uglifier => {:copyright => false, :mangle => false},
      :minify => true
    }.freeze
    
    def initialize args = {}
      args = DEFAULTS.merge(args||{})
      
      args.each do |k,v|
        instance_variable_set "@#{k}", v.dup.freeze
      end
    end
    
    def env
      return @env if @env
      
      case
      when defined?(ENVIRONMENT)
        ENVIRONMENT
      when defined?(Merb)
        Merb.env
      when defined?(Rails)
        Rails.env
      else
        ENV['RACK_ENV'] || ENV['RAILS_ENV']
      end
    end
    
    def env? e
      env == e
    end
    
    def prod?
      env == 'production'
    end
    
    def dev?
      !prod?
    end
    
    def find_file_from_relative_path path
      a = Assette.config.file_paths.find do |pp|
        File.exist?(File.join(pp,path))
      end
      File.join(a,path)
    end
    
    def find_target_from_relative_path path
      Assette.config.file_paths.find do |p|
        Assette::Reader.possible_targets(File.join(p,path)).find do |pp|
          File.exist?(pp)
        end
      end
    end
    
    def build_target
      @asset_dir
    end
    
    def asset_hosts?
      !@asset_hosts.empty?
    end
    
    def compiling?
      !!compiling
    end

    def minify?
      !!minify
    end
    
    def asset_host i
      return '' unless asset_hosts?
      @asset_hosts[i % @asset_hosts.size]
    end
    
    def compiled_path str
      str = str.dup
      if sha
        case cache_method.to_s
        when 'path'
          str = File.join(sha,str)
        when 'param'
          str << (str.include?('?') ? '&' : '?')
          
          str << 'v=' << sha
        else
          warn('No cache compile method set (param or path)')
        end
      end
      
      str
    end
    
    class Builder
      
      attr_reader :__hsh__
      def initialize(file)
        @__str = File.open(file).read
        
        @__hsh__ = {}
      end
      
      def __run__
        instance_eval @__str
      end
      
      MULTIPLES.each do |m|
        eval <<-RB
        def #{m} *args
          @__hsh__[:#{m}s] ||= []
          @__hsh__[:#{m}s] |= args.flatten
        end
        
        def #{m}s *args
          @__hsh__[:#{m}s] = args.flatten
        end
        RB
      end
      
      SINGLES.each do |s|
        eval <<-RB
        def #{s} v
          @__hsh__[:#{s}] = v
        end
        RB
      end
      
      BLOCKS.each do |b|
        eval <<-RB
        def #{b} val=nil, &blk
          if val
            @__hsh__[:#{b}] ||= {}
            @__hsh__[:#{b}][val] = blk
          else
            @__hsh__[:#{b}] = blk
          end
        end
        RB
      end
      
      def to_hash
        @__hsh__
      end
      
    end
    
    class << self
      
      def load p
        b = Builder.new(p)
        b.__run__
        
        new b.to_hash
      end
      
    end
    
  end
  
end
