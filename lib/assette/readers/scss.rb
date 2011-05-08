require 'assette/readers/sass'
module Assette
  class Reader::Scss < Assette::Reader::Sass
  
  private

    def options
      super.merge :syntax => :scss
    end
  
  end
end