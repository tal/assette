require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Assette::Config do
  
  before do
    Assette.instance_variable_set :@config, nil
  end
  
  it "should recieve correct file" do
    Assette::Config.should_receive(:load).once.with('config/assets.rb')
    
    Dir.chdir(File.dirname(__FILE__) + '/../examples') { Assette.config }
  end
  
  describe "default file" do
    before(:all) do
      @dir_before = Dir.pwd
      Dir.chdir(File.dirname(__FILE__) + '/../examples')
    end

    after(:all) do
      Dir.chdir(@dir_before)
    end
    
    subject {Assette.config}

    it "should set file paths" do
      subject.file_paths.should == %w{public foo}
    end

    it "should set asset hosts" do
      subject.asset_hosts.should == %w{http://cdn1.gilt.com http://cdn2.gilt.com}
    end
    
    it "should set assets dir" do
      subject.asset_dir.should == 'myassets'
    end
    
    it "should set templates path" do
      subject.templates_path.should == 'myapp/templates'
    end
    
    it "should set templates format" do
      subject.template_format.should == 'GC.foo.t[{*path*}] = Handlebars.compile({*template*});'
    end
    
    it "should set after compile" do
      subject.after_compile.call.should == 3
    end
  end
  
end