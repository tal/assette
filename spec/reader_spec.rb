require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Assette::Reader do
  
  before(:all) do
    
    class Assette::Reader::Txt < Assette::Reader(:txt)
      def compile
        @file.text
      end
    end
    
  end
  
  it "should set outputs on creation" do
    Assette::Reader::Txt.outputs.should == :txt
  end
  
  it "should make the reader map" do
    Assette::Reader::ALL.should include('txt' => Assette::Reader::Txt)
  end
  
  it "should have mime type" do
    Assette::Reader::Txt.mime_type.should == MIME::Types.type_for("test.txt").first
  end
  
  it "should build the right target list" do
    targets = Assette::Reader.possible_targets('/test/.hidden/one.file.css')
    %w{
      /test/.hidden/one.file.css
      /test/.hidden/one.file.sass
      /test/.hidden/one.file.scss
    }.each do |p|
      targets.should include p
    end
    
    targets = Assette::Reader.possible_targets('/test/.hidden/file.js')
    targets.should include "/test/.hidden/file.js"
    targets.should include "/test/.hidden/file.coffee"
  end
end