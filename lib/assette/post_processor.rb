module Assette
  module PostProcessor
    extend self
    POST_PROCESSORS = Hash.new {|h,k| h[k] = []}
    
    def s
      POST_PROCESSORS
    end
    
    class Base
      
      def initialize(str, args={})
        @str = str; @args = args
      end
      
      def should_process?
        true
      end
      
      def processor
        raise Exception, "You must implement the processor method for #{self.class.inspect} (you can use the @str)"
      end
      
      def process
        return @str unless should_process?
        
        processor
      end
      
      class << self
        def inherited subclass
          return if subclass == Assette::PostProcessor::Base || subclass.inspect =~ /#<Class/
          
          if outputs
            Assette::PostProcessor::POST_PROCESSORS[outputs] |= [subclass]
          end
        end
        
        def outputs
          
        end
        
        def set_outputs val
          raise ArgumentError, 'must set outputs to a symbol' unless val.is_a?(Symbol)
          
          instance_eval <<-RUBY
          def outputs
            #{val.inspect}
          end
          RUBY
          val
        end
      end
    end
    
  end
  
  
  
  def self.PostProcessor(type)
    c = Class.new(PostProcessor::Base)
    c.set_outputs(type)
    c
  end
end