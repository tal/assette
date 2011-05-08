require 'sass'

class Assette::Reader::Sass < Assette::Reader(:css)
  
  def compile
    ::Sass::Engine.new(text,options).to_css
  end
  
private
  
  def options
    {
      :syndtax => :sass,
      :load_paths => [File.expand_path(@file.dirname)]|Assette.config.file_paths
    }
  end
end
