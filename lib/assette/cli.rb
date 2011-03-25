require 'thor'
require 'rack'
require 'rack/showexceptions'
require 'assette/server'
require 'fileutils'

begin
  require 'git'
rescue LoadError
end

module Assette
  
  class CLI < Thor
    ASSET_PREFIX_MATCHER = /^([a-f0-9]{9}|\d{6}_\d{6})\//
    
    
    include Thor::Actions
    DEFAULT_PID_FILE = '.assette_pid'
    class_option :'config-file', :desc => 'config file to use', :type => :string
    
    map "-v" => :version
    
    desc 'version', 'displays current gem version'
    def version
      say Assette::VERSION
    end
    
    desc 'server', 'Launches the assette server (should only be used for dev or behind a cdn)'
    method_option :port, :aliases => '-p', :type => :numeric
    method_option :'dont-daemonize', :aliases => '-D', :type => :boolean
    method_option :pid, :type => :string, :default => DEFAULT_PID_FILE, :description => 'file to store pid in'
    def server
      opts = {}
      opts[:Port] = options[:port] || 4747
      opts[:config] = File.join(File.dirname(__FILE__),'run.ru')
      
      unless options['dont-daemonize']
        opts[:daemonize] = true
        opts[:pid] = pid_file
      end
      
      say "Starting Assette server on port #{opts[:Port]}"
      ret = Rack::Server.start(opts)
    end
    
    desc "stop", "stops the assette server"
    method_option :pid, :type => :string, :default => DEFAULT_PID_FILE, :description => 'file pid is stored in'
    def stop
      if File.exist?(pid_file)
        pid = File.open(pid_file).read.chomp.to_i
        say "Killing server with PID #{pid}"
        Process.kill("INT",pid)
      else
        say "No pid file found at #{pid_file}"
      end
    end
    
    desc "compile", "Compile all the assettes in a folder for static serving"
    def compile
      files = []
      Assette.config.compiling = true
      
      unless File.exist?('assets')
        Dir.mkdir('assets')
      end
      
      sha = Git.open('..').log.first.sha[0...8] rescue Time.now.strftime("%y%m%d_%H%M%S")
      Assette.config.sha = sha
      
      Assette.config.file_paths.each do |path|
        Assette::Reader::ALL.keys.each do |extension|
          files |= Dir[File.join(path,'**',"*.#{extension}")]
        end
      end
      
      files.delete_if {|f| f =~ /\/_/} # remove any mixins to speed up process
      
      files = files.collect {|f| Assette::File.open(f)}
      
      File.open("assets/version","w") {|f| f.write(sha)}
      
      container = if Assette.config.cache_method.to_s == 'path'
        File.join(Assette.config.build_target,sha)
      else
        Assette.config.build_target
      end
      
      made_dirs = []
      
      say "Compiling all assete files to #{container}"
      
      files.each do |file|
        target_path = file.target_path
        
        Assette.config.file_paths.each do |p|
          target_path.gsub!(p,'')
        end
        
        new_path = File.join(container,target_path)
        
        create_file(new_path, file.all_code)
      end
      
    end
    
    def initialize(*)
      super
      get_services
    end
    
  private
    def set_color *args
      @shell.set_color(*args)
    end
    
    def get_services
      Assette.config(options['config-file'])
    end
    
    def pid_file
      @pid ||= begin
        pid = options.pid
        unless pid =~ /^\//
          pid = File.expand_path(File.join(Dir.pwd,pid))
        end
        
        pid
      end
    end
  end
  
end