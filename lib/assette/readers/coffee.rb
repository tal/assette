require 'open3'
require 'coffee-script'

class Assette::Reader::Coffee < Assette::Reader(:js)
  
  def compile
    self.class.compile_str text
  end
  
  class << self
    
    def compile_str text
      CoffeeScript.compile text
    end
    
    # Compile coffeescript using coffee binary.
    def compile_str_external text
      out = nil

      Open3.popen3('coffee -sc') do |stdin, stdout, stderr|
        stdin.puts(text)
        stdin.close_write
        out = stdout.read
      end

      out
    end
    
    def comment_str
      '#'
    end

    def comment_str_end
      ''
    end
  end
end