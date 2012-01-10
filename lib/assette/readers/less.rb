require 'less'

class Assette::Reader::Less < Assette::Reader(:css)

  LESSC = !`which lessc`.empty?

  def compile args={}

    if LESSC
      Assette.logger.info("less running") {"cd #{@file.dirname} && lessc < #{@file.filename}"}
      `cd #{@file.dirname} && lessc #{@file.filename}`
    else
      parser = Less::Parser.new({
        :paths => [File.expand_path(@file.dirname)]|Assette.config.file_paths,
        :filename => @file.filename
      })

      tree = parser.parse(text)

      tree.to_css(options.merge(args))
    end
  end
  
private

  def options
    Assette.config.less
  end
end
