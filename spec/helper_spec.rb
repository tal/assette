require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Assette::ViewHelper do
  
  after(:all) do
    Dir.chdir(@dir_before)
  end
  
  before(:all) do
    @dir_before = Dir.pwd
    Dir.chdir(File.dirname(__FILE__) + '/../examples')
  end
  
  describe Assette::ViewHelper::Development do
    before :all do
      Assette.config.env = 'development'
      
      class DevHelper
        include Assette::ViewHelper
      end

      @dev = DevHelper.new
    end
    
    it "should be a development helper" do
      @dev.should be_a Assette::ViewHelper::Development
    end
    
    it "should return dev tag" do
      tag = @dev.asset_tag 'javascripts/test.coffee'
      tag.should include '<script src="/__templates/foo" type="text/javascript"></script>'
      tag.should include '<script src="/javascripts/one.js?nodep" type="text/javascript"></script>'
      tag.should include '<script src="/javascripts/test.js?nodep" type="text/javascript"></script>'
    end
  end
  
  describe Assette::ViewHelper::Production do
    before :all do
      Assette.config.env = 'production'
      
      class ProdHelper
        include Assette::ViewHelper
        attr_reader :__asset_iterator
      end

      @prod = ProdHelper.new
    end
    
    it "should be a production helper" do
      @prod.should be_a Assette::ViewHelper::Production
    end
    
    it "should return prod tag" do
      tag = @prod.asset_tag 'javascripts/test.coffee'
      tag.strip.should == '<script src="http://cdn1.gilt.com/javascripts/test.js" type="text/javascript"></script>'
    end
    
    describe "cachebusting" do
      before :all do
        @pre_sha = Assette.config.sha
        Assette.config.sha = @sha = '1234567890abcdef'
      end

      after :all do
        Assette.config.sha = @pre_sha
      end

      it "should use path" do
        Assette.config.instance_variable_set(:@cache_method,'path')
        tag = @prod.asset_tag 'javascripts/test2.coffee'
        tag.strip.should include %Q{.gilt.com/#{@sha}/javascripts/test2.js}
      end

      it "should use param" do
        Assette.config.instance_variable_set(:@cache_method,'param')
        tag = @prod.asset_tag 'javascripts/test3.coffee'
        tag.strip.should include %Q{gilt.com/javascripts/test3.js?v=#{@sha}}
      end
    end
    
    describe "caching" do
      before do
        @prod2 = ProdHelper.new
        @prod3 = ProdHelper.new
      end
      
      it "should only generate a link the first time" do
        @prod2.should_not_receive(:__asset_tag)
        file = 'javascripts/asdfasdf.coffee'
        tag = @prod.asset_tag file
        tag2 = @prod2.asset_tag file
        
        tag.should == tag2
      end
    end
    
  end
  
end