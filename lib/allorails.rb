module Allorails  
  
  #autoload :Conf, 'allorails/conf'
  autoload :Api, 'allorails/api/api'
  
  #def self.Conf
  #  Allorails::Conf.instance
  #end

  autoload :Website, 'allorails/response/model'
  autoload :Country, 'allorails/response/model'
  autoload :Region, 'allorails/response/model'
  autoload :Market, 'allorails/response/model'
  autoload :Pricepoint, 'allorails/response/model'
  autoload :Price, 'allorails/response/model'
  autoload :Payout, 'allorails/response/model'
  autoload :PhoneNumber, 'allorails/response/model'
  autoload :Keyword, 'allorails/response/model'
  autoload :Partner, 'allorails/response/model'
  autoload :Code, 'allorails/response/model'

  module Request
    autoload :ApiRequest, 'allorails/request/request'
    autoload :OnetimePricingRequest, 'allorails/request/request'
    autoload :OnetimeDiscretePricingRequest, 'allorails/request/request'
    autoload :OnetimeValidateCodesRequest, 'allorails/request/request'
    autoload :ProductDetailRequest, 'allorails/request/request'
    autoload :TransactionPrepareRequest, 'allorails/request/request'
    autoload :TransactionDetailRequest, 'allorails/request/request'
    autoload :TransactionMerchantRequest, 'allorails/request/request'
    autoload :OnetimeButtonRequest, 'allorails/request/request'
    autoload :OnetimeDiscreteButtonRequest, 'allorails/request/request'
  end

  module Response
    autoload :ApiResponse,                    'allorails/response/api_response'
    autoload :ApiMappingResponse,             'allorails/response/api_mapping_response'
    autoload :OnetimePricingResponse,         'allorails/response/onetime_pricing_response'
    autoload :OnetimeValidateCodesResponse,   'allorails/response/onetime_validate_codes_response'
    autoload :ProductDetailResponse,          'allorails/response/product_detail_response'
    autoload :TransactionPrepareResponse,     'allorails/response/transaction_prepare_response'
    autoload :TransactionDetailResponse,      'allorails/response/transaction_detail_response'
    autoload :OnetimeButtonResponse,          'allorails/response/onetime_button_response'
  end

end

require 'allorails/core'

require 'allorails/errors/errors'

require 'allorails/rails'