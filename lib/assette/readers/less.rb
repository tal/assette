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

  class << self
    def tag path
      tag = <<-HTML
        <link href="#{path}" rel="stylesheet/less" type="text/css"  media="all" />
      HTML

      tag << %Q{<script src="#{Assette.config.less_js_path}?nodep" type="text/javascript"></script>} if Assette.config.less_js_path
    end
  end
end
