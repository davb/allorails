require 'net/http'
require 'cgi'
require 'digest'

module Allorails
  module Request
    
    class ApiRequest

      # API response format needed to provide response object mapping
      MAPPING_FORMAT = 'json'
      # API remote base path
      API_PATH = '/rest'

      ## Returns the remote path of the Allopass API service
      #
      #  @return (string) A remote path
      def _path
        self.class::PATH
      end

      # class of the Response
      ## Returns an object mapping the Allopass API response
      #
      #  @param signature (string) Expected response signature
      #  @param headers (list) Response HTTP headers
      #  @param body (string) Raw response data 
      #
      #  @return ApiResponse An object mapping the Allopass API response
      def _new_response(signature, headers, body)
        raise "new_response is not implemented"
      end

      ## Constructor
      #
      #  @param parameters (array) Parameters to the API call
      #  @param mapping (boolean) Wether to return a raw response or an object
      #  @param emailAccount (string) Configurated email account
      def initialize(parameters, mapping = true, email_account = nil)
        @_mapping = mapping
        @_parameters = _stringify_symbols parameters
        @_email_account = email_account
      end

      ## Call the Allopass API and returns the response (raw or object)
      #
      #  @return ApiResponse The API response
      def call()
        headers, body = self._build_parameters._sign._call
        signature = self._hash(body + Allorails.config.private_key(@_email_account))

        if (@_mapping)
          return self._new_response(signature, headers, body)
        else
          return Allorails::Response::ApiResponse.new(signature, headers, body)
        end
      end
      
      # Internal method to turn symbols (keys and values) into strings
      def _stringify_symbols x
        return x.to_s if x.is_a?(Symbol)
        return x.map{|y| _stringify_symbols y} if x.is_a?(Array)
        return x.inject({}) {|h, (k,v)| h[_stringify_symbols k] = _stringify_symbols v; h} if x.is_a?(Hash)
        return x
      end

      ## Internal method building special required API parameters
      #
      #  @return ApiRequest Class instance for chaining purpose
      def _build_parameters
        formats = ['json', 'xml']

        @_parameters.update({
          'api_ts' => Time.now.to_i,
          'api_key' => Allorails.config.api_key(@_email_account),
          'api_hash' => Allorails.config.default_hash
        })

        if @_parameters.has_key?('format')
          if (@_mapping)
            @_parameters['format'] = self::MAPPING_FORMAT
          elsif !formats.include?(@_parameters['format'])
            @_parameters['format'] = Allorails.config.default_format
          end
        else
          @_parameters['format'] = Allorails.config.default_format
        end

        self
      end

      ## Internal methods used to sign the request call
      #
      #  @return ApiRequest Class instance for chaining purpose
      def _sign
        params = @_parameters.dup
        
        if params.has_key?('code')
          params['code'] = params['code'].join
        end
        
        sign = params.sort.map{|p| "#{p[0]}#{p[1]}"}.join
        @_parameters['api_sig'] = self._hash(sign + Allorails.config.private_key(@_email_account))
        
        self
      end

      ## Internal method hashing data with defined cipher #TODO en prenant en compte la donnée incrite dans les confs
      #
      #  @parameter data (string) Data to hash
      #
      #  @throws ApiMissingHashFeatureError If defined cipher method isn'h available
      def _hash(data)
        ::Digest::SHA1.hexdigest(data)
      end

      ## Internal method deciding wether to use a POST request
      #
      #  @return (boolean) True to use POST
      def _is_http_post
        false
      end

      ## Internal method calling the Allopass API
      #
      #  @return (tuple) Pair containing response headers and body
      def _call
        protocol = Allorails.config.network_protocol
        server   = Allorails.config.host
        timeout  = Allorails.config.network_timeout.to_f

        port    = protocol == 'https' ? 443 : 80
        uri     = URI(protocol + '://' + server + ApiRequest::API_PATH + _path)
        method  = _is_http_post ? 'POST' : 'GET'
        headers = {
          "Content-Type" => "application/x-www-form-urlencoded; charset=utf-8",
          "User-Agent" => "Allopass-ApiKit-AlloRails"
        }
        
        # use a proxy?
        use_proxy = false
        http_class = if use_proxy then Net::HTTP::Proxy('127.0.0.1', 9999) else Net::HTTP end

        # prepare and send HTTP request
        http_class.start(uri.host, port, :use_ssl => uri.scheme == 'https') do |http|
          
          if method == 'GET'
            uri.query = _encode_parameters
            req = http_class::Get.new uri.request_uri
          else
            #uri.query = _encode_parameters
            req = http_class::Post.new uri.request_uri
            req.body = _encode_parameters
          end    
          
          # set headers
          headers.each_pair{|k, v| req[k] = v}
          
          # send the request and see if successful
          case res = http.request(req)
            when Net::HTTPSuccess then return [res.to_hash, res.body]
            else raise Allorails::ApiUnavailableResourceError, "Request failed: #{res.body}"
          end
        end
      end

      ## Internal method encoding request paramters
      #
      #  @return (string) Encoded request parameters
      def _encode_parameters
        params = @_parameters.dup
        # The Allopass API expects an array of codes encoded
        # in a slightly different matter than urlencode does
        if params.has_key?('code')
          codes = params.delete('code')
          hash_codes = Hash[[0..codes.length-1].map{|i| ["code[#{i}]",codes[i]]}]
          params = params.merge(hash_codes)          
        end
        
        URI::encode params.collect { |k,v| "#{k}=#{v}" }.join('&') #CGI::escape(v.to_s)
      end
    
    end # -- end class ApiRequest
    
    
    ## Class providing a onetime pricing API request
    class OnetimePricingRequest < ApiRequest
      PATH = '/onetime/pricing'
      
      def _new_response(signature, headers, body)
        Allorails::Response::OnetimePricingResponse.new(signature, headers, body)
      end
    end
    
    
    ## Class providing a onetime dicrete pricing API request
    class OnetimeDiscretePricingRequest < ApiRequest
      PATH = '/onetime/discrete-pricing'
      
      def _new_response(signature, headers, body)
        Allorails::Response::OnetimePricingResponse.new(signature, headers, body)
      end
    end
    
    
    ## Class providing a onetime validate codes API request
    class OnetimeValidateCodesRequest < ApiRequest
      PATH = '/onetime/validate-codes'
      
      def _is_http_post
        true
      end
      
      def _new_response(signature, headers, body)
        Allorails::Response::OnetimeValidateCodesResponse.new(signature, headers, body)
      end
    end
    
    
    ## Class providing a product detail API request
    class ProductDetailRequest < ApiRequest
      PATH = '/product'
      
      def _new_response(signature, headers, body)
        Allorails::Response::ProductDetailResponse.new(signature, headers, body)
      end
    end
    
    
    ## Class providing a transaction prepare API request
    class TransactionPrepareRequest < ApiRequest
      PATH = '/transaction/prepare'
      
      def _is_http_post
        true
      end
      
      def _new_response(signature, headers, body)
        Allorails::Response::TransactionPrepareResponse.new(signature, headers, body)
      end
    end
    
    
    ## Class providing a transaction detail API request
    class TransactionDetailRequest < ApiRequest
      PATH = '/transaction'
      
      def _new_response(signature, headers, body)
        Allorails::Response::TransactionDetailResponse.new(signature, headers, body)
      end
    end
    
    
    ## Class providing a transaction detail from merchant transaction id API request
    class TransactionMerchantRequest < ApiRequest
      PATH = '/transaction/merchant'
      
      def _new_response(signature, headers, body)
        Allorails::Response::TransactionDetailResponse.new(signature, headers, body)
      end
    end
    
    
    ## Class providing a onetime button API request
    class OnetimeButtonRequest < ApiRequest
      PATH = '/onetime/button'
      
      def _is_http_post
        true
      end
      
      def _new_response(signature, headers, body)
        Allorails::Response::OnetimeButtonResponse.new(signature, headers, body)
      end
    end
    
    
    ## Class providing a onetime discrete button API request
    class OnetimeDiscreteButtonRequest < ApiRequest
      PATH = '/onetime/discrete-button'
      
      def _is_http_post
        true
      end
      
      def _new_response(signature, headers, body)
        Allorails::Response::OnetimeButtonResponse.new(signature, headers, body)
      end
    end
    
  end
end
