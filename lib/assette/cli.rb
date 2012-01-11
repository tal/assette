require 'thor'
require 'rack'
require 'rack/showexceptions'
require 'assette/server'
require 'fileutils'

begin
  require 'git'
rescue LoadError
end

# Remove the chdir, not sure why he put that there.
# Bad hack, gotta figure out another way to fix this
class Rack::Server
  def daemonize_app
    if RUBY_VERSION < "1.9"
      exit if fork
      Process.setsid
      exit if fork
      # Dir.chdir "/"
      STDIN.reopen "/dev/null"
      STDOUT.reopen "/dev/null", "a"
      STDERR.reopen "/dev/null", "a"
    else
      Process.daemon
    end
  end
end

module Assette
  
  class CLI < Thor
    ASSET_PREFIX_MATCHER = /^([a-f0-9]{9}|\d{6}_\d{6})\//
    
    
    include Thor::Actions
    DEFAULT_PID_FILE = '.assette_pid'
    class_option :'config-file', :desc => 'config file to use', :type => :string
    class_option :trace, :type => :boolean, :default => false
    
    map "-v" => :version
    
    desc 'version', 'displays current gem version'
    def version
      say Assette::VERSION
    end
    
    desc 'server', 'Launches the assette server (should only be used for dev or behind a cdn)'
    method_option :port, :aliases => '-p', :type => :numeric
    method_option :'dont-daemonize', :aliases => '-D', :type => :boolean
    method_option :pid, :type => :string, :default => DEFAULT_PID_FILE, :description => 'file to store pid in'
    def server(cmd = nil)
      if cmd.nil? || cmd == 'start'
        
        opts = {}
        opts[:Port] = options[:port] || 4747
        opts[:config] = File.join(File.dirname(__FILE__),'run.ru')
      
        unless options['dont-daemonize']
          
          if File.exist?(pid_file)
            pid = File.open(pid_file).read.chomp.to_i
            begin
              Process.kill("INT",pid)
              say "Server already running with PID #{pid}, killing before restart"
            rescue Errno::ESRCH

            end
          end
          
          opts[:daemonize] = true
          opts[:pid] = pid_file
        else
          Assette.logger.level = Logger::DEBUG
          Assette.logger.datetime_format = "%H:%M:%S"
          Assette.logger.formatter = Proc.new do |severity, datetime, progname, msg|
            "#{severity}: #{progname} - #{msg}\n"
          end
        end
      
        say "Starting Assette server on port #{opts[:Port]}"
        ret = Rack::Server.start(opts)
      elsif cmd == 'stop'
        if File.exist?(pid_file)
          pid = File.open(pid_file).read.chomp.to_i
          say "Killing server with PID #{pid}"
          Process.kill("INT",pid)
        else
          say "No pid file found at #{pid_file}"
        end
      end
    end
    
    desc "compile", "Compile all the assettes in a folder for static serving"
    method_option :minified, :type => :boolean, :default => false, :description => "only compile minified files"
    method_option :static_min, :type => :boolean, :default => false, :description => "only copy static files and minified files"
    def compile
      files = []
      all_files = []
      Assette.config.compiling = true
      
      unless File.exist?('assets')
        Dir.mkdir('assets')
      end
      
      sha = Git.open('.').log.first.sha[0...8] rescue Time.now.strftime("%y%m%d_%H%M%S")
      Assette.config.sha = sha
      
      Assette.config.file_paths.each do |path|
        all_files |= Dir[File.join(path,'**',"*")]
        Assette::Reader::ALL.keys.each do |extension|
          files |= Dir[File.join(path,'**',"*.#{extension}")]
        end
      end
      
      not_compiled = all_files - files
      
      files.delete_if {|f| f =~ /\/_/} # remove any mixins to speed up process
      
      # files = files.collect {|f| Assette::File.open(f)}
      
      container = if Assette.config.cache_method.to_s == 'path'
        File.join(Assette.config.build_target,sha)
      else
        Assette.config.build_target
      end
      
      made_dirs = []
      
      say "Compiling all asset files to #{container}"

      files_to_minify = []
      
      files.each do |file_path|
        Assette::File.open(file_path) do |file|

          if file.minify?
            files_to_minify.push(file_path)
          else
            unless options.minified? || options.static_min?
              target_path = file.relative_target_path
              
              Assette.config.file_paths.each do |p|
                # target_path.gsub!(p,'')
              end
              
              new_path = File.join(container,target_path)
              
              Assette.logger.debug("Compiling file") {"#{file.path} -> #{new_path}"}
              create_file(new_path, file.all_code)
            end
          end
        end
      end

      Assette.config.minifying do
        say "\nCreating minified versions of files" unless files_to_minify.empty?

        files_to_minify.each do |file_path|
          Assette::File.open(file_path) do |file|
            target_path = file.relative_target_path

            new_path = File.join(container,target_path).sub(/(\.[A-Za-z0-9]{2,10})$/,'.min\1')

            Assette.logger.debug("Compiling minified file") {"#{file.path} -> #{new_path}"}
            create_file(new_path, file.all_code)
          end
        end
      end
      
      say "\nCopying all non-compiled assets to #{container}"
      not_compiled.each do |file|
        next if File.directory?(file)
        next if options.minified?
        target_path = file.dup

        Assette.config.file_paths.each do |p|
          target_path.gsub!(Regexp.new(p+'/'),'')
        end
        
        new_path = File.join(container,target_path)
        
        Assette.logger.debug("Copying file") {"#{file} -> #{new_path}"}
        copy_file(file,new_path)
      end


      version_file = Assette.config.asset_version_file
      File.delete(version_file) if File.exist?(version_file)
      create_file(version_file,sha)

      Assette.config.after_compile.call(sha)
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