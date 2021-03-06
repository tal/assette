require 'json'
require 'forwardable'
require 'mime/types'
require 'logger'
require 'pp'

coffee_type = MIME::Type.new('text/coffeescript') do |t|
  t.encoding = '8bit'
  t.extensions = %w{coffee}
end

sass_type = MIME::Type.new('text/sass') do |t|
  t.encoding = '8bit'
  t.extensions = %w{sass scss}
end

MIME::Types.add coffee_type, sass_type

module Assette
  extend self
  CONFIG_WRAPPER = 'ASSETTE CONFIG'
  VERSION = File.open(File.expand_path(File.dirname(__FILE__)+'/../VERSION')).read.freeze
  
  def logger
    @logger ||= Logger.new('/dev/null')
  end
  
  def logger=(l)
    @logger = l
  end

  class CompilationError < StandardError; end;
end

%w{config reader readers post_processor post_processors
  compiled_file file template_set template view_helper}.each do |f|
  require File.dirname(__FILE__)+'/assette/'+f
end
