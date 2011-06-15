require 'helper'
require 'rack/test'
require 'assette/server'

class ServerTest < Test::Unit::TestCase
  include Rack::Test::Methods
  
  def app
    Assette::Server
  end
  
  def test_test_coffee
    get "/javascripts/test.js"
    
    assert last_response.ok?
    is_js?
    has_pre_template
    has_foo_template
    has_bar_template false
  end
  
  def test_nodep
    get "/javascripts/test.js?nodep"
    
    assert last_response.ok?
    is_js?
    has_pre_template false
    has_foo_template false
    has_bar_template false
  end
  
  def test_two_scss
    get '/stylesheets/two2.css'
    
    assert last_response.ok?
    is_css?
    assert_match /#foo3/, last_response.body
    assert_match /#one/, last_response.body
  end
  
  def test_all_template
    get '/__templates/all'
    
    assert last_response.ok?
    is_js?
    has_pre_template
    has_foo_template
    has_bar_template
  end
  
  def test_all_template2
    get '/__templates/foo:bar'
    
    assert last_response.ok?
    is_js?
    has_pre_template
    has_foo_template
    has_bar_template
    
    get '/__templates/bar:foo.js'
    
    assert last_response.ok?
    is_js?
    has_pre_template
    has_foo_template
    has_bar_template
  end
  
  def test_foo_template
    get '/__templates/foo'

    assert last_response.ok?
    is_js?
    has_pre_template
    has_foo_template
    has_bar_template false
  end
  
  def test_bar_template
    get '/__templates/bar.js'
    
    assert last_response.ok?
    is_js?
    has_pre_template
    has_foo_template false
    has_bar_template
  end
  
  def test_getting_js_dependencies
    get "/javascripts/test.js?deparr"
    json = nil
    assert_nothing_raised do
      json = JSON.parse(last_response.body)
    end
    
    assert json['dependencies'].is_a?(Array)
    assert_equal json['target_type'], 'application/javascript'
    assert json['dependencies'].include?('/__templates/foo')
    assert json['dependencies'].include?('/javascripts/one.js')
    assert json['dependencies'].include?('/javascripts/test.js')
  end
  
  def test_getting_js_dependencies
    get '/stylesheets/two2.css?deparr'
    json = nil
    assert_nothing_raised do
      json = JSON.parse(last_response.body)
    end
    
    assert json['dependencies'].is_a?(Array)
    assert_equal json['target_type'], 'text/css'
    assert json['dependencies'].include?('/stylesheets/two2.css')
    
    
    get '/stylesheets/two.css?deparr'
    json = JSON.parse(last_response.body)
    
    assert json['dependencies'].is_a?(Array)
    assert_equal json['target_type'], 'text/css'
    assert_equal json['dependencies'], ['/stylesheets/one.css','/stylesheets/two.css']
  end
  
private
  
  def is_js?
    assert_equal last_response.content_type, 'application/javascript'
  end
  
  def is_css?
    assert_equal last_response.content_type, 'text/css'
  end
  
  def has_pre_template(tf = true)
    has_or_not tf, /Handlebars\.registerPartial =/, last_response.body
  end
  
  def has_foo_template(tf = true)
     has_or_not tf, /GC\.foo\.t\["foo\/index"\]/, last_response.body
  end
  
  def has_bar_template(tf = true)
    has_or_not tf, /GC\.foo\.t\["bar\/index"\]/, last_response.body
  end
  
  def has_or_not(tf, *args)
    args.flatten!
    if tf
      assert_match(*args)
    else
      assert_no_match(*args)
    end
  end
  
end
