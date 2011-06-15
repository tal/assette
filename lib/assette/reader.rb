module Assette
  module Reader
    extend self
    OUTPUTS = Hash.new {|h,k| h[k] = []}
    ALL = {}
    OUTPUT_MAP = {}
    
    def possible_targets path
      match = path.match(/(.+\.)([a-z]+)$/i)
      return [] unless match
      file = match[1]
      ext = match[2]
      
      OUTPUTS[ext.to_sym].collect { |cla| file + cla.extension }
    end
    
    def target_class ex
      Assette::Reader::ALL[Assette::Reader::OUTPUT_MAP[ex]]
    end
    
    class Base
      attr_reader :file
      def initialize(file)
        @file = file
      end
      
      def text
        @file.text
      end
      
      def compile
        raise Exception, "You must implement the compile method for #{self.class.inspect}"
      end
      
      class << self
        
        # Gets called twice currenlty, once on Class.new(Reader::Base)
        # and once on the subclassing. Gotta fix that
        def inherited subclass
          return if subclass == Assette::Reader::Base || subclass.inspect =~ /#<Class/
          
          if outputs
            Assette::Reader::OUTPUTS[outputs] |= [subclass]
          end
          
          subclass.set_extension
        end
        
        def extension
          if m = self.inspect.match(/::(\w+)$/i)
            m[1].downcase
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
        
        def set_extension val = nil
          if val
            raise ArgumentError, 'must set extension to a symbol' unless val.is_a?(Symbol)
            instance_eval <<-RUBY
            def extension
              #{val.inspect}
            end
            RUBY
          end
          
          if ex = extension
            Assette::Reader::ALL[ex] = self
            Assette::Reader::OUTPUT_MAP[ex] = outputs.to_s
          end
        end
        
        def mime_type
          @mime_type ||= MIME::Types.type_for("test.#{extension}").first
        end
        
      end
    
    end
    
    class UnknownReader < StandardError; end
  end
  
  def self.Reader(type)
    c = Class.new(Reader::Base)
    c.set_outputs(type)
    c
  end
  
end
