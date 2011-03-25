fname = File.join(File.dirname(__FILE__),'post_processors','*.rb')
Dir[fname].each do |f|
  require f
end