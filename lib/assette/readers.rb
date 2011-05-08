%w{
  css
  js
  coffee
  sass
  scss
}.each do |f|
  require File.join(File.dirname(__FILE__),'readers',"#{f}.rb")
end