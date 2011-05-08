class Assette::Reader::Css < Assette::Reader(:css)
  
  def compile
    @file.text
  end
  
  class << self
    
    def error str, stack = nil
      <<-CSS
      body:before {
        position: absolute;
        top: 0px;
        padding: 10px;
        font-size: 18px;
        text-align: center;
        width: 100%;
        display: block;
        content: #{str.inspect};
        background-color: #992E40;
        color: white;
        font-weight:bold;
        z-index: 9999;
      }
      CSS
    end
    
    def comment_str
      '/* %s */'
    end
    
  end
end