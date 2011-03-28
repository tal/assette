class Assette::Reader::Css < Assette::Reader(:css)
  
  def compile
    @file.text
  end
  
  class << self
    
    def comment_str
      '/* %s */'
    end
    
  end
end