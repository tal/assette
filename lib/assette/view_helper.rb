module Assette
  module ViewHelper
    
    module Development
      def asset_tag file
        output = ["<!-- Assets for #{file} -->"]
        real_path = Assette.config.find_file_from_relative_path(file)
        f = Assette::File.open(real_path)
        
        output << Assette::Reader::Js.tag("/__templates/#{f.templates.join(':')}") unless f.templates.empty?
        
        f.dependencies.each do |d|
          output << d.dev_tag
        end
        output << f.dev_tag
        
        output << "<!-- END #{file} -->"
        
        output.join("\n")
      end
    end
    
    module Production
      ASSET_TAGS = Hash.new
      
      # Store the path name for each asset so to speed up things a little and to make sure it's alwasy getting the smae host
      def asset_tag file
        ASSET_TAGS[file] ||= __asset_tag(file)
      end
      
      def __asset_tag file
        ex = file.match(/\.(\w+)$/)
        if ex && target_class = Assette::Reader.target_class(ex[1])
          @__asset_iterator ||= -1 # Conerns about whether this will get re_instantiated on each request must investigate
          
          file.gsub!(/\.(\w+)$/) do |s|
            ".#{Assette::Reader::OUTPUT_MAP[$1]}"
          end
          
          url = Assette.compiled_path @__asset_iterator+=1, file
          
          target_class.tag url
        else
          <<-HTML
          <!-- Can't find file or reader for #{file.inspect}-->
          HTML
        end
      end
    end
    
    def self.included receiver
      if Assette.config.prod?
        receiver.send :include, Production
      else
        receiver.send :include, Development
      end
    end
    
  end
end
