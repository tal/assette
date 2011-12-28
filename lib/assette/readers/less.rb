require 'less'

class Assette::Reader::Less < Assette::Reader(:css)

  def compile args={}
    parser = Less::Parser.new({
      :paths => [File.expand_path(@file.dirname)]|Assette.config.file_paths,
      :filename => @file.filename
    })

    tree = parser.parse(text)

    tree.to_css(options.merge(args))
  end
  
private

  def options
    Assette.config.less
  end
end
