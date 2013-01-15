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
        unless (@_headers['x-allopass-response-signature'] || []).include?(@_signature)
          raise Allorails::ApiFalseResponseSignatureError
        end
      end

    end
  end
end