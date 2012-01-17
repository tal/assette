class Assette::Reader::Less < Assette::Reader(:css)

  LESSC = !`which lessc`.empty?

  begin
    require 'less'
  rescue LoadError => e
    unless LESSC
      warn("No version of less installed please run npm install -g less; or gem install less (not preferred)")
    end
  end

  def compile args={}

    if LESSC
      Assette.logger.info("less running") {"cd #{@file.dirname} && lessc < #{@file.filename}"}
      `cd #{@file.dirname} && lessc #{@file.filename}`
    elsif defined?(Less)
      parser = Less::Parser.new({
        :paths => [File.expand_path(@file.dirname)]|Assette.config.file_paths,
        :filename => @file.filename
      })

      tree = parser.parse(text)

      tree.to_css(options.merge(args))
    else
      warn("cannot compile because no less interpreter installed #{@file.path}")

      text
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
