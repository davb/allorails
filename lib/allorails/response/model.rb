module Allorails


  ## Basis for the models used in the Apikit object responses
  # extends ApiMappingResponse to inherit the node_reader helper
  class Base < Allorails::Response::ApiMappingResponse 
    
    def initialize(node)
      @json = node
    end
    
  end

  
  ## Class providing object mapping of a website item 
  class Website < Base
  
    ## Provides the website id
    #  @return (int) website id
    node_reader :id, Integer
  
    ## Provides the website name
    #  @return (string) website name
    node_reader :name
  
    ## Provides the website url
    #  @return (string) website url
    node_reader :url
  
    ## Checks wether the website's audience is restricted
    #  @return (boolean) wether the website's audience is restricted
    def audience_restricted?
      @json.audience_restricted == 'true'
    end
  
    ## Provides the website category
    #  @return (string) website category
    node_reader :category

  end
  
  
  ## Class providing object mapping of a country item 
  class Country < Base
  
    ## Provides the country code
    #  @return (string) country code (two characters)
    node_reader :code
  
    ## Provides the country name
    #  @return (string) country name
    node_reader :name
    
  end
  
  
  ## Class providing object mapping of a region item 
  class Region < Base
  
    ## Provides the region name
    #  @return (string) region name
    node_reader :name
  
    ## Provides the countries in the region
    #  @return (Array) region's countries
    def countries
      json.children.values.map{|c| ::Allorails::Country.new(c)}
    end
  
  end
  
  
  ## Class providing object mapping of a market item
  class Market < Base
  
    ## Provides the country code
    #  @return (string) country code (two characters)
    node_reader :country_code
  
    ## Provides the country name
    #  @return (string) country name
    node_reader :country
  
    ## Provides the pricepoints available in this market
    #  @return (Array) available pricepoints (list of Pricepoint objects)
    def pricepoints
      json.pricepoint.map{|c| ::Allorails::Pricepoint.new(c)}
    end
    
  end


  ## Class providing object mapping of a price item
  class Price < Base
  
    ## Provides the currency
    #  @return (string) currency (three characters)
    node_reader :currency
  
    ## Provides the amount
    #  @return (float) amount
    node_reader :amount, Float
  
    ## Provides the day's exchange rate
    #  @return (float) exchange rate
    node_reader :exchange, Float
  
    ## Provides the reference currency
    #  @return (string) reference currency
    node_reader :reference_currency
  
    ## Provides the amount in the reference currency
    #  @return (float) reference amount
    node_reader :reference_amount, Float

  end
  
  ## Class providing object mapping of a payout item
  class Payout < Base
  
    ## Provides the currency
    #  @return (string) currency (three characters)
    node_reader :currency
  
    ## Provides the amount
    #  @return (float) amount
    node_reader :amount, Float
  
    ## Provides the day's exchange rate
    #  @return (float) exchange rate
    node_reader :exchange, Float
  
    ## Provides the reference currency
    #  @return (string) reference currency
    node_reader :reference_currency
  
    ## Provides the amount in the reference currency
    #  @return (float) reference amount
    node_reader :reference_amount, Float
  
  end
  
  
  ## Class providing object mapping of a phone number item
  class PhoneNumber < Base
  
    ## Provides the phone number
    #  @return (string) phone number
    node_reader :value
  
    ## Provides the description of the phone number
    #  @return (string) description
    node_reader :description
    
  end
  
  
  ## Class providing object mapping of a keyword item
  class Keyword < Base
  
    ## Provides the keyword name
    #  @return (string) keyword name
    node_reader :name
  
    ## Provides the keyword's shortcode
    #  @return (string) shortcode
    node_reader :shortcode
  
    ## Provides the keyword operators
    #  @return (string) keyword operators
    node_reader :operators
  
    ## Provides the number of billed messages of the keyword
    #  @return (int) number of billed messages
    node_reader :number_billed_messages, Integer
  
    ## Provides a description of the keyword
    #  @return (string) description
    node_reader :description
    
  end
  
  
  ## Class providing object mapping of a pricepoint item
  class Pricepoint < Base
  
    ## Provides the pricepoint's id
    #  @return (int) pricepoint id
    node_reader :id, Integer
  
    ## Provides the pricepoint's type
    #  @return (string) pricepoint type
    node_reader :type
  
    ## Provides the pricepoint's country code
    #  @return (string) country code (two characters)
    node_reader :country_code
  
    ## Provides price information
    #  @return (Price) price information
    node_reader :price, ::Allorails::Price
  
    ## Provides the pricepoint's payout
    #  @return (Payout) pricepoint's payout
    node_reader :payout, ::Allorails::Payout
  
    ## Provides the buy url
    #  @return (string) buy url
    node_reader :buy_url
  
    ## Provides the pricepoint's phone numbers
    #  @return (list) pricepoint's phone number (list of PhoneNumber objects)
    def phone_numbers
      return nil if json.phone_numbers.nil?
      json.phone_numbers.children.values.map{|c| ::Allorails::PhoneNumber(c)}
    end
  
    ## Provides the pricepoint's keywords
    #  @return (list) pricepoint's keywords (list of Keyword objects)
    def keywords
      return nil if json.keywords.nil?
      json.keywords.children.values.map{|c| ::Allorails::Keyword(c)}
    end
  
    ## Provides the pricepoint's description
    #  @return (string) pricepoint's description
    node_reader :description
  
  end
  
  
  ## Class providing object mapping of a partner item
  class Partner < Base
  
    ## Provides the partner id
    #  @return (int) partner id
    node_reader :id, Integer
  
    ## Provides the parnter's amount share
    #  @return (float) parnter's amount share
    node_reader :share, Float
  
    ## Provides the associated map id
    #  @return (int) map id
    def map
      return nil unless json.map.is_a?(String) && json.map.length > 0
      json.map.to_i
    end
    
  end
  
  
  ## Class providing object mapping of a code item
  class Code < Base
  
    ## Provides the code value
    #  @return (string) code
    node_reader :value
  
    ## Provides the pricepoint's description
    #  @return (string) pricepoint's description
    node_reader :pricepoint, ::Allorails::Pricepoint
  
    ## Provides price information
    #  @return (Price) price information
    node_reader :price, ::Allorails::Price
  
    ## Provides paid price information
    #  @return (Price) paid price information
    node_reader :paid, ::Allorails::Price
  
    ## Provides the pricepoint's payout
    #  @return (Payout) pricepoint's payout
    node_reader :payout, ::Allorails::Payout
    
  end
      
end