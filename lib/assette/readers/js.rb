class Assette::Reader::Js < Assette::Reader(:js)
  
  def compile
    @file.text
  end
  
  class << self
    
    def comment_str
      '// %s'
    end
  end
end
