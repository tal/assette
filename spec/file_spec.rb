require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Assette::File do
  
  before(:all) do
    @dir_before = Dir.pwd
    Dir.chdir(File.dirname(__FILE__) + '/../examples')
  end
  
  after(:all) do
    Dir.chdir(@dir_before)
  end
  
  describe "javascript" do

    subject do
      Assette::File.open('public/javascripts/foo.js')
    end

    it "should equal" do
      subject.should == Assette::File.open(subject.path)
    end

    it "should description" do
      subject.dependencies.should have(2).files
    end

    it "should have the right reader class" do
      subject.reader_class.should == Assette::Reader::Js
    end

    it "should compile" do
      subject.code.should == subject.text
    end
    
    it "should have templates" do
      all_code = subject.all_code
      all_code.should include('{{foo}}')
    end
    
  end
  
  describe Assette::Reader::Coffee do
    subject do
      Assette::File.open('public/javascripts/test.coffee')
    end
    
    it "should description" do
      subject.dependencies.should have(1).file
    end
    
    it "should " do
      subject.code.should == "(function() {\n  var test;\n  test = 'test';\n}).call(this);\n"
    end
    
    it "should " do
      all_code = subject.all_code
      all_code.should include('window.one = 1;')
      all_code.should include('test = \'test\';')
    end
  end
  
  describe Assette::Reader::Css do
    subject do
      Assette::File.open('public/stylesheets/two.css')
    end
     
    it "should work" do
      all_code = subject.all_code
      all_code.should include('#one {}')
      all_code.should include('#two {}')
    end
  end
  
  describe Assette::Reader::Scss do
    subject do
      Assette::File.open('public/stylesheets/two2.scss')
    end
    
    it "should work" do
      all_code = subject.all_code
      all_code.should include 'width: 800px;'
      all_code.should include 'width: 2400px;'
    end
  end
  
  describe Assette::Reader::Sass do
    subject do
      Assette::File.open('public/stylesheets/one1.sass')
    end
    
    it "should work" do
      all_code = subject.all_code
      all_code.should include 'width: 800px;'
    end
  end
end