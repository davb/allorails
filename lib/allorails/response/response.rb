require 'net/http'
require 'json'

module Allorails
  module Response
    
    class ApiResponse
      
      ##
      # Constructor
      #  @param signature (string) Expected response signature
      #  @param headers (list) Response HTTP headers
      #  @param body (string) Raw response data
      def initialize(signature, headers, body)
        @_signature = signature
        @_headers = headers
        @_body = body
      end
      
      ##
      # Internal method checking the response
      # @throws ApiFalseResponseSignature If the expected signature is not found among response headers
      def _verify
        raise Allorails::ApiFalseResponseSignatureError unless @_headers['x-allopass-response-signature'].include?(@_signature)
      end
      
      ## Custom print result
      def to_s
        @_body
      end
    
    end # -- end class ApiResponse
    
    
    class JsonNode
      
      attr_reader :children
      attr_reader :attributes
      
      def initialize(json_obj)
        @attributes = json_obj.delete('@attributes') || {}
        @children = {}
        json_obj.each_pair do |k, v|
          @children[k] = v.is_a?(Hash) ? JsonNode.new(v) : (v.is_a?(Array) ? v.map{|el| JsonNode.new(el)} : v)
        end
      end
      
      def method_missing(m, *args, &block)
        m = m.to_s
        return attributes[m] if attributes.has_key?(m)
        return children[m] if children.has_key?(m)
        return nil
      end
      
    end
    
    
    class ApiMappingResponse < ApiResponse
      
      attr_reader :json
      
      ##
      # Constructor
      #  @param signature (string) Expected response signature
      #  @param headers (list) Response HTTP headers
      #  @param body (string) Raw response data
      def initialize(signature, headers, body)
        super(signature, headers, body)
        begin
          @json = JsonNode.new(JSON.parse(body)['response'] || {})
        rescue JSON::ParserError => e
          raise Allorails::ApiWrongFormatResponseError
        end
        _verify
      end
      
      ##
      # Internal method checking the response
      # @throws ApiFalseResponseSignature If the expected signature is not found among response headers
      def _verify
        if json.code.nil? || json.code.to_i != 0
          raise Allorails::ApiRemoteErrorError
        end
        super
      end
      
      ##
      # Internal method allowing easy reading of JSON nodes
      #  @param (sym) name of the (top-level) node that needs to be read
      #  @param (Class) type to which the result should be cast
      def self.node_reader(node_name, type = String)
        # define a Proc to cast the node's text to the specified type
        cast = case true
          when type == String then Proc.new{|x| x.to_s}
          when type == Integer then Proc.new{|x| x.to_i}
          when type == Float then Proc.new{|x| to_f}
          when type == DateTime then Proc.new{|x| x.date.nil? ? (x.timestamp.nil? ? nil : DateTime.strptime(x.timestamp, "%s")) : DateTime.strptime(x.date)}
          else Proc.new{|x| type.new x}
        end
        # add a method accessing the node and casting the text
        send :define_method, node_name do
          result = json.send(node_name)
          return cast.call(result) unless result.nil?
        end
      end
      
    end
    
    
    class OnetimePricingResponse < ApiMappingResponse
    
      ## Provides the creation date
      #  @return (DateTime) Creation date
      node_reader :creation_date, DateTime
    
      ## Provides the customer ip
      #  @return (string) customer ip
      node_reader :customer_ip
    
      ## Provides the customer country
      #  @return (string) customer country
      node_reader :customer_country
    
      ## Provides the website
      #  @return (Website) website
      node_reader :website, Website
    
      ## Provides the pricepoints by countries
      #  @return (Array) available countries (list of Country object)
      def countries
        countries = []
        json.countries.children.values.each{|r| countries += r.children.values.map{|c| ::Allorails::Country.new(c)}}
        countries
      end
    
      ## Provides the pricepoints by region
      #  @return (Array) available regions (list of Regions object)
      def regions
        json.countries.children.values.map{|r| ::Allorails::Region.new(r)}
      end
    
      ## Provides the pricepoints by markets
      #  @return (list) available markets (list of Market object)
      def markets
        json.markets.children.values.map{|m| ::Allorails::Market.new(m)}
      end

    end
    
    
    ## Class defining a onetime validate-codes request's response
    class OnetimeValidateCodesResponse < ApiMappingResponse
      ## The validation is successful
      VALIDATESCODES_SUCCESS = 0
    
      ## The validation failed
      VALIDATESCODES_FAILED = 1
    
      ## Provides the validation status
      #  @return (int) validation status
      node_reader :status, Integer
    
      ## Provides the validation status description
      #  @return (string) validation status description
      node_reader :status_description
    
      ## Provides access type
      #  @return (string) access type
      node_reader :access_type
    
      ## Provides the transaction id
      #  @return (string) transaction id
      node_reader :transaction_id
    
      ## Provides price information
      #  @return (Price) price information
      node_reader :price, ::Allorails::Price
    
      ## Provides paid price information
      #  @return (Price) paid price information
      node_reader :paid, ::Allorails::Price
    
      ## Provides the validation date
      #  @return (datetime.datetime) validation date
      node_reader :validation_date, DateTime
    
      ## Provides the product name
      #  @return (string) product name
      node_reader :product_name
    
      ## Provides the website
      #  @return (Website) website
      node_reader :website, Website
    
      ## Provides the customer ip
      #  @return (string) customer ip
      node_reader :customer_ip
    
      ## Provides the customer country
      #  @return (string) customer country
      node_reader :customer_country
    
      ## Provides the expected number of codes
      #  @return (int) expected number of codes
      node_reader :expected_number_of_codes, Integer
    
      ## Provides the codes you tried to validate
      #  @return (Array) list of Code objects
      def codes
        json.codes.children.values.map{|c| ::Allorails::Code.new(c)}
      end
    
      ## Provides the merchant transaction id
      #  @return (string) merchant transaction id
      node_reader :merchant_transaction_id
    
      ## Provides the client data
      #  @return (string) client data
      node_reader :data
    
      ## Provides the affiliation code
      #  @return (string) affiliation code
      node_reader :affiliate
    
      ## Provides information about the associated partners
      #  @return (list) partners information (list of Partner objects)
      def partners
        json.partners.children.values.map{|c| ::Allorails::Partner.new(c)}
      end

    end
  
  
    ## Class defining a product detail request's response
    class ProductDetailResponse < ApiMappingResponse
    
      ## Provides the product id
      #  @return (int) product id
      node_reader :id, Integer
    
      ## Provides the product key
      #  @return (string) product key
      node_reader :key
    
      ## Provides access type
      #  @return (string) access type
      node_reader :access_type
    
      ## Provides the creation date
      #  @return (datetime.datetime) Creation date
      node_reader :creation_date, DateTime
    
      ## Provides the product name
      #  @return (string) product name
      node_reader :name
    
      ## Provides the website
      #  @return (Website) website
      node_reader :website, Website
    
      ## Provides the expected number of codes
      #  @return (int) expected number of codes
      node_reader :expected_number_of_codes, Integer
    
      ## Provides the purchase url
      #  @return (string) purchase url
      node_reader :purchase_url
    
      ## Provides the forward url
      #  @return (string) forward url
      node_reader :forward_url
    
      ## Provides the error url
      #  @return (string) error url
      node_reader :error_url
    
      ## Provides the notification url
      #  @return (string) notification url
      node_reader :notification_url
    
    end
    
    
    ## Class defining a transaction prepare request's response
    class TransactionPrepareResponse < ApiMappingResponse
    
      ## Provides access type
      #  @return (string) access type
      node_reader :access_type
    
      ## Provides the transaction id
      #  @return (string) transaction id
      node_reader :transaction_id
    
      ## Provides the creation date
      #  @return (datetime.datetime) Creation date
      node_reader :creation_date, DateTime
    
      ## Provides price information
      #  @return (Price) price information
      node_reader :price, ::Allorails::Price
    
      ## Provides information about the pricepoint
      #  @return (Pricepoint) pricepoint information
      node_reader :pricepoint, ::Allorails::Pricepoint
    
      ## Provides the website
      #  @return (Website) website
      node_reader :website, Website
    
      ## Provides the buy url
      #  @return (string) buy url
      node_reader :buy_url
    
      ## Provides the checkout button
      #  @return (string) checkout button (html code)
      node_reader :checkout_button
    
    end
    
    
    ## Class defining a transaction detail request's response
    class TransactionDetailResponse < ApiMappingResponse
    
      ## The transaction is at first step : initialization
      INIT = -1
    
      ## The transaction is successful
      SUCCESS = 0
    
      ## The transaction failed due to insufficient funds
      INSUFFICIENT_FUNDS = 1
    
      ## The transaction timeouted
      TIMEOUT = 2
    
      ## The transaction has been cancelled by user
      CANCELLED = 3
    
      ## The transaction has been blocked due to fraud suspicions
      ANTI_FRAUD = 4
    
      ## Provides the transaction status
      #  @return (int) transaction status
      node_reader :status, Integer
    
      ## Provides the validation status description
      #  @return (string) validation status description
      node_reader :status_description
    
      ## Provides access type
      #  @return (string) access type
      node_reader :access_type
    
      ## Provides the tansaction id
      #  @return (string) transaction id
      node_reader :transaction_id
    
      ## Provides price information
      #  @return (Price) price information
      node_reader :price, ::Allorails::Price
    
      ## Provides paid price information
      #  @return (Price) paid price information
      node_reader :paid, ::Allorails::Price
    
      ## Provides the creation date
      #  @return (datetime.datetime) Creation date
      node_reader :creation_date, DateTime
    
      ## Provides the end date
      #  @return (datetime.datetime) end date
      node_reader :end_date, DateTime
    
      ## Provides the product name
      #  @return (string) product name
      node_reader :product_name
    
      ## Provides the customer ip
      #  @return (string) customer ip
      node_reader :customer_ip
    
      ## Provides the customer country
      #  @return (string) customer country
      node_reader :customer_country
    
      ## Provides the expected number of codes
      #  @return (int) expected number of codes
      node_reader :expected_number_of_codes, Integer
    
      ## Provides the codes associated with the transaction
      #  @return (list) list of codes (list of string)
      def codes
        json.codes.children.values.map{|c| ::Allorails::Code.new(c)}
      end
    
      ## Provides the merchant transaction id
      #  @return (string) merchant transaction id
      node_reader :merchant_transaction_id
    
      ## Provides the client data
      #  @return (string) client data
      node_reader :data
    
      ## Provides the affiliation code
      #  @return (string) affiliation code
      node_reader :affiliate
    
      ## Provides information about the associated partners
      #  @return (list) partners information (list of Partner objects)
      def partners
        json.partners.children.values.map{|c| ::Allorails::Partner.new(c)}
      end
    
    end
    
    
    ## Class defining a onetime button request's response
    class OnetimeButtonResponse < ApiMappingResponse
    
      ## Provides access type
      #  @return (string) access type
      node_reader :access_type
    
      ## Provides the button id
      #  @return (string) button id
      node_reader :button_id
    
      ## Provides the creation date
      #  @return (datetime.datetime) Creation date
      node_reader :creation_date, DateTime
    
      ## Provides the website
      #  @return (Website) website
      node_reader :website, Website
    
      ## Provides the buy url
      #  @return (string) buy url
      node_reader :buy_url
    
      ## Provides the checkout button
      #  @return (string) checkout button (html code)
      node_reader :checkout_button
    
    end
    
  end #-- end module Allorails::Response
end #-- end module Allorails
