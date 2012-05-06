module Allorails
  
  class Api
    
    attr_accessor :email
    
    ## Constructor
    #
    #  @param configuration_email_account (string) Email of the configurated account
    #  If email is null, the first account is considered
    def initialize(email = nil)
      self.email = email
    end
 
    ## Method performing a onetime pricing request
    # 
    #  @param parameters (Hash) Query string parameters of the API call
    #  @param mapping (boolean) Should the response be an object mapping or a plain response
    # 
    #  @return (ApiResponse) The API call response
    #  Will be a OnetimePricingResponse instance if mapping is true, an ApiResponse if not
    # 
    #  @code
    #  # Make sure the apikit is in your search path
    #  import allopass_apikit.api
    #  api = allopass_apikit.api.AllopassAPI()
    #  response = api.getOnetimePricing({'site_id': 127042, 'country': 'FR'})
    #  print("{}\n-----".format(response.getWebsite().getName()))
    #  for country in response.getCountries()
    #    print("{}\n-----".format(country.getCode()))
    #    print("{}\n-----".format(country.getName()))
    #  @endcode
    def get_onetime_pricing(parameters, mapping = true)
      Allorails::Request::OnetimePricingRequest.new(parameters, mapping, self.email).call
    end
 
    ## Method performing a onetime discrete pricing request
    # 
    #  @param parameters (array) Query string parameters of the API call
    #  @param mapping (boolean) Should the response be an object mapping or a plain response
    # 
    #  @return (ApiResponse) The API call response
    #  Will be a OnetimePricingResponse instance if mapping is true, an ApiResponse if not
    # 
    #  @code
    #  # Make sure the apikit is in your search path
    #  import allopass_apikit.api
    #  api = allopass_apikit.api.AllopassAPI()
    #  response = api.getOnetimeDiscretePricing({'site_id': 127042, 'country': 'FR', 'amount': 12})
    #  print("{}\n-----".format(response.getWebsite().getName()))
    #  for country in response.getCountries()
    #    print("{}\n-----".format(country.getCode()))
    #    print("{}\n-----".format(country.getName()))
    #  @endcode
    def get_onetime_discrete_pricing(parameters, mapping = true)
      Allorails::Request::OnetimeDiscretePricingRequest.new(parameters, mapping, self.email).call
    end
 
    ## Method performing a onetime validate codes request
    # 
    #  @param parameters (array) Query string parameters of the API call
    #  @param mapping (boolean) Should the response be an object mapping or a plain response
    # 
    #  @return (ApiResponse) The API call response
    #  Will be a OnetimeValidateCodesResponse instance if mapping is true, an ApiResponse if not
    # 
    #  @code
    #  # Make sure the apikit is in your search path
    #  import allopass_apikit.api
    #  api = allopass_apikit.api.AllopassAPI()
    #  response = api.validateCodes({'site_id': 127042, 'product_id': 354926, 'code': ('9M7QU457',)})
    #  print("{}\n-----".format(response->getStatus()))
    #  print("{}\n-----".format(response->getStatusDescription()))
    #  @endcode
    def validate_codes(parameters, mapping = true)
      Allorails::Request::OnetimeValidateCodesRequest.new(parameters, mapping, self.email).call
    end
 
    ## Method performing a onetime button request
    # 
    #  @param parameters (array) Query string parameters of the API call
    #  @param mapping (boolean) Should the response be an object mapping or a plain response
    # 
    #  @return (ApiResponse) The API call response
    #  Will be a OnetimeButtonResponse instance if mapping is true, an ApiResponse if not
    # 
    #  @code
    #  # Make sure the apikit is in your search path
    #  import allopass_apikit.api
    #  api = allopass_apikit.api.AllopassAPI()
    #  response = api.createButton({'site_id': 127042, 'amount': 12.3, 'reference_currency': 'EUR', 'price_mode': 'price', 'price_policy': 'high-only', 'product_name': 'premium sms access', 'forward_url': 'http://product-page.com'})
    #  print("{}\n-----".format(response.getButtonId()))
    #  print("{}\n-----".format(response.getBuyUrl()))
    #  @endcode
    def create_button(parameters = {}, mapping = true)
      Allorails::Request::OnetimeButtonRequest.new(parameters, mapping, self.email).call
    end
    
    ## Method performing a onetime discrete button request
    # 
    #  @param parameters (array) Query string parameters of the API call
    #  @param mapping (boolean) Should the response be an object mapping or a plain response
    # 
    #  @return (ApiResponse) The API call response
    #  Will be a OnetimeButtonResponse instance if mapping is true, an ApiResponse if not
    # 
    #  @code
    #  # Make sure the apikit is in your search path
    #  import allopass_apikit.api
    #  api = allopass_apikit.api.AllopassAPI()
    #  response = api.createDiscreteButton({'site_id': 127042, 'amount': 1.1, 'reference_currency': 'EUR', 'price_mode': 'price', 'price_policy': 'high-only', 'product_name': 'premium sms access', 'forward_url': 'http://product-page.com'})
    #  print("{}\n-----".format(response.getButtonId()))
    #  print("{}\n-----".format(response.getBuyUrl()))
    #  @endcode
    def create_discrete_button(parameters = {}, mapping = true)
      Allorails::Request::OnetimeDiscreteButtonRequest.new(parameters, mapping, self.email).call
    end
 
    ## Method performing a product detail request
    # 
    #  @param id (integer) The product id
    #  @param parameters (array) Query string parameters of the API call
    #  @param mapping (boolean) Should the response be an object mapping or a plain response
    # 
    #  @return (ApiResponse) The API call response
    #  Will be a ProductDetailResponse instance if mapping is true, an ApiResponse if not
    # 
    #  @code
    #  # Make sure the apikit is in your search path
    #  import allopass_apikit.api
    #  api = allopass_apikit.api.AllopassAPI()
    #  response = api.getProduct(354926)
    #  print({}"\n-----".format(response.getName()))
    #  @endcode
    def get_product(id, parameters = {}, mapping = true)
      Allorails::Request::ProductDetailRequest.new(parameters.merge({'id'=>id}), mapping, self.email).call
    end
 
    ## Method performing a transaction prepare request
    # 
    #  @param parameters (array) Query string parameters of the API call
    #  @param mapping (boolean) Should the response be an object mapping or a plain response
    # 
    #  @return (ApiResponse) The API call response
    #  Will be a TransactionPrepareResponse instance if mapping is true, an ApiResponse if not
    # 
    #  @code
    #  # Make sure the apikit is in your search path
    #  import allopass_apikit.api
    #  api = allopass_apikit.api.AllopassAPI()
    #  response = api.prepareTransaction({'site_id': 127042, 'pricepoint_id': 2, 'product_name': 'premium calling product', 'forward_url': 'http://product-page.com', 'amount': 15})
    #  print("{}\n-----".format(response.getBuyUrl()))
    #  print("{}\n-----".format(response.getCheckoutButton()))
    #  @endcode
    def prepareTransaction(parameters, mapping = true)
      Allorails::Request::TransactionPrepareRequest.new(parameters, mapping, self.email).call
    end
 
    ## Method performing a transaction detail request based on the transaction id
    # 
    #  @param id (string) The transaction id
    #  @param parameters (array) Query string parameters of the API call
    #  @param mapping (boolean) Should the response be an object mapping or a plain response
    # 
    #  @return (ApiResponse) The API call response
    #  Will be a TransactionDetailResponse instance if mapping is true, an ApiResponse if not
    # 
    #  @code
    #  # Make sure the apikit is in your search path
    #  import allopass_apikit.api
    #  api = allopass_apikit.api.AllopassAPI()
    #  response = api.getTransaction('3f5506ac-5345-45e4-babb-96570aafdf6a');
    #  print("{}\n-----".format(response.getPaid().getCurrency()))
    #  print("{}\n-----".format(response.getPaid().getAmount()))
    #  @endcode
    def getTransaction(id, parameters = {}, mapping = true)
      Allorails::Request::TransactionDetailRequest.new(parameters.merge({'id'=>id}), mapping, self.email).call
    end
 
    ## Method performing a transaction detail request based on the merchant transaction id
    # 
    #  @param id (string) The merchant transaction id
    #  @param parameters (array) Query string parameters of the API call
    #  @param mapping (boolean) Should the response be an object mapping or a plain response
    # 
    #  @return (ApiResponse) The API call response
    #  Will be a TransactionDetailResponse instance if mapping is true, an ApiResponse if not
    # 
    #  @code
    #  # Make sure the apikit is in your search path
    #  import allopass_apikit.api
    #  api = allopass_apikit.api.AllopassAPI()
    #  response = api.getTransactionMerchant('TRX20091112134569B8');
    #  print("{}\n-----".format(response.getPaid().getCurrency()))
    #  print("{}\n-----".format(response.getPaid().getAmount()))
    #  @endcode
    def getTransactionMerchant(id, parameters = {}, mapping = true)
      Allorails::Request::TransactionMerchantRequest.new(parameters.merge({'id'=>id}), mapping, self.email).call
    end
    
  end
  
end