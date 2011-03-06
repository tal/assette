$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rubygems'
require 'assette'
require 'assette/server'

run Assette::Server