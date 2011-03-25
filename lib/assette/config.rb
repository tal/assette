module Assette
  def config(optional_path=nil)
    return @config if @config && !optional_path
    
    f = %w{assets.rb config/assets.rb}
    f.unshift(optional_path.to_s) if optional_path

    p = f.find { |path| File.exist?(path) }
    
    @config = Assette::Config.load(p)
  end
  
  class Config    
    MULTIPLES = %w{file_path asset_host}.freeze
    SINGLES = %w{asset_dir templates_path template_format}.freeze
    
    OPTIONS = begin
      arr = MULTIPLES.collect do |m|
        "#{m}s"
      end
      arr += SINGLES
    end.freeze
    
    attr_reader *OPTIONS
    attr_accessor :compiling, :sha
    
    DEFAULTS = {
      :asset_dir => 'assets',
      :asset_hosts => [],
      :file_paths => %w{public},
      :templates_path => 'app/templates',
      :template_format => 'AT.t[{*path*}] = {*template*};'
    }.freeze
    
    def initialize args = {}
      args = DEFAULTS.merge(args||{})
      
      args.each do |k,v|
        instance_variable_set "@#{k}", v.dup.freeze
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
    
    def asset_host i
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
