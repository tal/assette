%w{
  css
  js
  coffee
  sass
  scss
  less
}.collect do |f|
  File.join(File.dirname(__FILE__),'readers',"#{f}.rb")
end.each do |f|
  require f
end