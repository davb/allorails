require 'nokogiri'

module Allorails
  module Response

    ## Basis of an object mapped API response
    class ApiMappingResponse < Allorails::Response::ApiResponse
      
      attr_reader :xml
      
      ##
      # Constructor
      #  @param signature (string) Expected response signature
      #  @param headers (list) Response HTTP headers
      #  @param body (string) Raw response data
      def initialize(signature, headers, body)
        super(signature, headers, body)
        # parse the XML response
        @xml = Nokogiri.XML(body)
        # error if no root element
        raise Allorails::ApiWrongFormatResponseError if @xml.root.nil?
        # verify the response
        _verify
      end
      
      ##
      # Internal method checking the response
      # @throws ApiRemoteErrorError If response doesn't contain valid XML
      def _verify
        raise Allorails::ApiRemoteErrorError if @xml.root[:code] != '0'
        # call the parent _verify method which will check the signature
        super
      end
      
      ##
      # Internal method allowing easy reading of XML nodes
      #  @param (sym) name of the node that needs to be read
      #  @param (Class) type to which the result should be cast
      def self.node_reader(node_name, type = String)
        # define a Proc to cast the node's text to the specified type
        node_value = case true
          when type == String then Proc.new{|x| x.text}
          when type == Integer then Proc.new{|x| x.text.to_i}
          when type == Float then Proc.new{|x| x.text.to_f}
          when type == DateTime then Proc.new{|x|
            if x.respond_to?(:attribute) && (ts = x.attribute('timestamp'))
              DateTime.strptime(ts.value, "%s")
            elsif x.respond_to?(:attribute) && (d = x.attribute('date'))
              DateTime.strptime(d.value)
            else
              nil
            end
          }
          else Proc.new{|x| type.new x}
        end
        # add a method accessing the node and casting the text
        send :define_method, node_name do
          node = xml.css(node_name.to_s).first
          return node_value.call(node) unless node.nil?
        end
      end

      ##
      # Internal method allowing easy reading of XML attributes
      #  @param (sym) name of the attribute that needs to be read
      #  @param (Class) type to which the result should be cast
      def self.attribute_reader(attr_name, type = String)
        # define a Proc to cast the attribute's value to the specified type
        attr_value = case true
          when type == String then Proc.new{|x| x.value}
          when type == Integer then Proc.new{|x| x.value.to_i}
          when type == Float then Proc.new{|x| x.value.to_f}
          when type == DateTime then Proc.new{|x|
            if x.respond_to?(:attribute) && (ts = x.attribute('timestamp'))
              DateTime.strptime(ts.value, "%s")
            elsif x.respond_to?(:attribute) && (d = x.attribute('date'))
              DateTime.strptime(d.value)
            else
              nil
            end
          }
          else Proc.new{|x| type.new x}
        end
        # add a method accessing the node and casting the text
        send :define_method, attr_name do
          att = xml.attribute(attr_name.to_s)
          return attr_value.call(att) unless att.nil?
        end
      end
      
    end
  end
end