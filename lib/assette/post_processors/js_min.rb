# Available options and their defaults are
# 
# {
#   :mangle => true, # Mangle variables names
#   :toplevel => false, # Mangle top-level variable names
#   :except => [], # Variable names to be excluded from mangling
#   :max_line_length => 32 * 1024, # Maximum line length
#   :squeeze => true, # Squeeze code resulting in smaller, but less-readable code
#   :seqs => true, # Reduce consecutive statements in blocks into single statement
#   :dead_code => true, # Remove dead code (e.g. after return)
#   :lift_vars => false, # Lift all var declarations at the start of the scope
#   :unsafe => false, # Optimizations known to be unsafe in some situations
#   :copyright => true, # Show copyright message
#   :ascii_only => false, # Encode non-ASCII characters as Unicode code points
#   :inline_script => false, # Escape </script
#   :quote_keys => false, # Quote keys in object literals
#   :beautify => false, # Ouput indented code
#   :beautify_options => {
#     :indent_level => 4,
#     :indent_start => 0,
#     :space_colon => false
#   }
# }

require 'uglifier'

module Assette
  class PostProcessor::JSMin < Assette::PostProcessor(:js)

    def should_process?
      Assette.config.compiling?
    end

    def processor
      puts @str
      Uglifier.compile(@str)
    end

  end
end