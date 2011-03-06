fname = File.join(File.dirname(__FILE__),'readers','*.rb')
Dir[fname].each do |f|
  require f
end