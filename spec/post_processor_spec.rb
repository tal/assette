require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Assette::PostProcessor do
  
  before(:all) do
    @dir_before = Dir.pwd
    Dir.chdir(File.dirname(__FILE__) + '/../examples')
  end
  
  after(:all) do
    Dir.chdir(@dir_before)
  end

  describe Assette::PostProcessor::JSMin do
    before(:all) do
      Assette.config.compiling = true
      Assette.config.sha = "1234567"
    end
    
    after(:all) do
      Assette.config.compiling = nil
    end

    subject do
      Assette::File.open('public/javascripts/foo.js')
    end

    it "should minify the js" do
      subject.all_code.should == ''
    end
  end
  
  describe Assette::PostProcessor::CacheBuster do
    
    before(:all) do
      Assette.config.compiling = true
      Assette.config.sha = "1234567"
    end
    
    after(:all) do
      Assette.config.compiling = nil
    end
    
    subject do
      Assette::File.open('public/stylesheets/two2.scss')
    end
    
    describe "with asset cdn paths" do
      before(:all) do
        Assette.config.instance_variable_set :@asset_hosts, %w{http://cdn1.gilt.com http://cdn2.gilt.com}
      end
      
      describe "path changing" do
        before(:all) do
          Assette.config.instance_variable_set :@cache_method, 'path'
        end
        
        it "does something" do
          subject.all_code.should include('gilt.com/1234567/images/mystuff/goat.se?test=1"')
          subject.all_code.should include('gilt.com/1234567/images/mystuff/goa-t.se"')
          subject.all_code.should include('gilt.com/1234567/images/mystuff/go_at.se"')
        end
      end
      
      
      describe "param changing" do
        before(:all) do
          Assette.config.instance_variable_set :@cache_method, 'param'
        end
        
        it "does something" do
          subject.all_code.should include('gilt.com/images/mystuff/goat.se?test=1&v=1234567"')
          subject.all_code.should include('gilt.com/images/mystuff/goa-t.se?v=1234567"')
          subject.all_code.should include('gilt.com/images/mystuff/go_at.se?v=1234567"')
        end
      end
      
    end
    
  end
  
end