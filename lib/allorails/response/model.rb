module Allorails


  ## Basis for the models used in the Apikit object responses
  # extends ApiMappingResponse to inherit the node_reader helper
  class Base < Allorails::Response::ApiMappingResponse 
    
    def initialize(node)
      @xml = node
    end
    
  end

  
  ## Class providing object mapping of a website item 
  class Website < Base
  
    ## Provides the website id
    #  @return (int) website id
    attribute_reader :id, Integer
  
    ## Provides the website name
    #  @return (string) website name
    attribute_reader :name
  
    ## Provides the website url
    #  @return (string) website url
    attribute_reader :url
  
    ## Checks wether the website's audience is restricted
    #  @return (boolean) wether the website's audience is restricted
    def audience_restricted?
      xml.attribute('audience_restricted') == 'true'
    end
  
    ## Provides the website category
    #  @return (string) website category
    attribute_reader :category

  end
  
  
  ## Class providing object mapping of a country item 
  class Country < Base
  
    ## Provides the country code
    #  @return (string) country code (two characters)
    attribute_reader :code
  
    ## Provides the country name
    #  @return (string) country name
    attribute_reader :name
    
  end
  
  
  ## Class providing object mapping of a region item 
  class Region < Base
  
    ## Provides the region name
    #  @return (string) region name
    attribute_reader :name
  
    ## Provides the countries in the region
    #  @return (Array) region's countries
    def countries
      xml.css('country').map{|c| Allorails::Country.new(c)}
    end
  
  end
  
  
  ## Class providing object mapping of a market item
  class Market < Base
  
    ## Provides the country code
    #  @return (string) country code (two characters)
    attribute_reader :country_code
  
    ## Provides the country name
    #  @return (string) country name
    attribute_reader :country
  
    ## Provides the pricepoints available in this market
    #  @return (Array) available pricepoints (list of Pricepoint objects)
    def pricepoints
      xml.css('pricepoint').map{|c| Allorails::Pricepoint.new(c)}
    end
    
  end


  ## Class providing object mapping of a price item
  class Price < Base
  
    ## Provides the currency
    #  @return (string) currency (three characters)
    attribute_reader :currency
  
    ## Provides the amount
    #  @return (float) amount
    attribute_reader :amount, Float
  
    ## Provides the day's exchange rate
    #  @return (float) exchange rate
    attribute_reader :exchange, Float
  
    ## Provides the reference currency
    #  @return (string) reference currency
    attribute_reader :reference_currency
  
    ## Provides the amount in the reference currency
    #  @return (float) reference amount
    attribute_reader :reference_amount, Float

  end
  
  ## Class providing object mapping of a payout item
  class Payout < Base
  
    ## Provides the currency
    #  @return (string) currency (three characters)
    attribute_reader :currency
  
    ## Provides the amount
    #  @return (float) amount
    attribute_reader :amount, Float
  
    ## Provides the day's exchange rate
    #  @return (float) exchange rate
    attribute_reader :exchange, Float
  
    ## Provides the reference currency
    #  @return (string) reference currency
    attribute_reader :reference_currency
  
    ## Provides the amount in the reference currency
    #  @return (float) reference amount
    attribute_reader :reference_amount, Float
  
  end
  
  
  ## Class providing object mapping of a phone number item
  class PhoneNumber < Base
  
    ## Provides the phone number
    #  @return (string) phone number
    attribute_reader :value
  
    ## Provides the description of the phone number
    #  @return (string) description
    node_reader :description
    
  end
  
  
  ## Class providing object mapping of a keyword item
  class Keyword < Base
  
    ## Provides the keyword name
    #  @return (string) keyword name
    attribute_reader :name
  
    ## Provides the keyword's shortcode
    #  @return (string) shortcode
    attribute_reader :shortcode
  
    ## Provides the keyword operators
    #  @return (string) keyword operators
    attribute_reader :operators
  
    ## Provides the number of billed messages of the keyword
    #  @return (int) number of billed messages
    attribute_reader :number_billed_messages, Integer
  
    ## Provides a description of the keyword
    #  @return (string) description
    node_reader :description
    
  end
  
  
  ## Class providing object mapping of a pricepoint item
  class Pricepoint < Base
  
    ## Provides the pricepoint's id
    #  @return (int) pricepoint id
    attribute_reader :id, Integer
  
    ## Provides the pricepoint's type
    #  @return (string) pricepoint type
    attribute_reader :type
  
    ## Provides the pricepoint's country code
    #  @return (string) country code (two characters)
    attribute_reader :country_code
  
    ## Provides price information
    #  @return (Price) price information
    node_reader :price, Allorails::Price
  
    ## Provides the pricepoint's payout
    #  @return (Payout) pricepoint's payout
    node_reader :payout, Allorails::Payout
  
    ## Provides the buy url
    #  @return (string) buy url
    node_reader :buy_url
  
    ## Provides the pricepoint's phone numbers
    #  @return (list) pricepoint's phone number (list of PhoneNumber objects)
    def phone_numbers
      xml.css('phone_number').map{|c| Allorails::PhoneNumber.new(c)}
    end
  
    ## Provides the pricepoint's keywords
    #  @return (list) pricepoint's keywords (list of Keyword objects)
    def keywords
      xml.css('keyword').map{|c| Allorails::Keyword.new(c)}
    end
  
    ## Provides the pricepoint's description
    #  @return (string) pricepoint's description
    node_reader :description
  
  end
  
  
  ## Class providing object mapping of a partner item
  class Partner < Base
  
    ## Provides the partner id
    #  @return (int) partner id
    attribute_reader :id, Integer
  
    ## Provides the parnter's amount share
    #  @return (float) parnter's amount share
    attribute_reader :share, Float
  
    ## Provides the associated map id
    #  @return (int) map id
    def map
      if (map = xml.attribute('map')) && map.text.length > 0
        return map.to_i
      end
    end
    
  end
  
  
  ## Class providing object mapping of a code item
  class Code < Base
  
    ## Provides the code value
    #  @return (string) code
    node_reader :value
  
    ## Provides the pricepoint's description
    #  @return (string) pricepoint's description
    node_reader :pricepoint, Allorails::Pricepoint
  
    ## Provides price information
    #  @return (Price) price information
    node_reader :price, Allorails::Price
  
    ## Provides paid price information
    #  @return (Price) paid price information
    node_reader :paid, Allorails::Price
  
    ## Provides the pricepoint's payout
    #  @return (Payout) pricepoint's payout
    node_reader :payout, Allorails::Payout
    
  end
      
end