require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Templates" do
  before(:all) do
    @dir_before = Dir.pwd
    Dir.chdir(File.dirname(__FILE__) + '/../examples')
  end
  
  after(:all) do
    Dir.chdir(@dir_before)
  end
  
  
  describe Assette::TemplateSet do
  
    it "should get correct list of files" do
      f = Assette::Template.open("myapp/templates/foo/index.html.mustache")
      
      a = Assette::TemplateSet.new(:all)
      a.templates.should include f
      
      p = Assette::Template.open("myapp/templates/foo/_partial.html.mustache")
      a = Assette::TemplateSet.new(:foo)
      a.templates.should == [p,f]
    end
    
    it "should compile" do
      a = Assette::TemplateSet.new(:all)
      c = a.compile
      c.should include('{{foo}}')
      c.should include('Handlebars.registerPartial("foo/partial",')
      c.should include('Handlebars.compile("<div>')
      
      a = Assette::TemplateSet.new(:foo)
      a.compile.should include('{{foo}}')
    end
  
  end

  describe Assette::Template do
  
    subject do
      Assette::Template.open("myapp/templates/foo/index.html.mustache")
    end
  
  end
end
