require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'assette/server'

describe Assette::Server do
  before(:all) do
    @dir_before = Dir.pwd
    Dir.chdir(File.dirname(__FILE__) + '/../examples')
  end
  
  after(:all) do
    Dir.chdir(@dir_before)
  end
  
  it "should be implemented"
  
  it "should use Rack::File"
end