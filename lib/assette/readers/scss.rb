class Assette::Reader::Scss < Assette::Reader::Sass
  
private

  def options
    super.merge :syntax => :scss
  end

end