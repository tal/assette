module Assette
  class PostProcessor::CSSMin < Assette::PostProcessor(:css)

    def should_process?
      Assette.logger.debug("Testing post processor #{self.class}") {"Assette.config.compiling?: #{Assette.config.compiling?} Assette.config.minifying?: #{Assette.config.minifying?} minify?: #{minify?}"}
      # puts Assette.config.minifying? && minify?
      Assette.config.minifying? && minify?
    end

    def minify?
      # minify = false
      # minify ||= @args[:parent].minify? if @args[:parent]
      # minify &&= !file.never_minify?
      # puts @args[:parent].minify? if @args[:parent]
      # puts !file.never_minify?
      # minify
      minify ||= @args[:parent].minify? if @args[:parent]
    end

    def processor
      Reader::Less.new(@file).compile(:compress => true).chomp
    end

  end
end
