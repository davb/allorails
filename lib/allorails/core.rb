require 'set'

module Allorails
  
  module Core
    
    # Holds the configuration options for Allorails
    #
    class Configuration
      
      # creates a new Configuration object
      # @param options
      # @option options
      def initialize options = {}
        options.each_pair do |opt_name, value|
          opt_name = opt_name.to_sym
          if self.class.accepted_options.include?(opt_name)
            supplied[opt_name] = value
          end
        end
      end
      
      # creates a new Configuration object with the given modifications
      # does not modify the current object
      def with options = {}
        # symbolize option keys
        options = symbolize_keys options
        values = supplied.merge(options)
        
        if supplied == values
          self # no changes
        else
          self.class.new(values)
        end
      end
      
      # API key and secret key depend on the account
      def api_key email = nil
        account(email)[:api_key]
      end
      
      def private_key email = nil
        account(email)[:private_key]
      end
      
      
    protected
      
      # symbolize Hash keys
      def symbolize_keys hash
        hash.inject({}) {|h, (k,v)| h[k.to_sym] = v.is_a?(Hash) ? symbolize_keys(v) : v; h }
      end
    
    
      # Returns the account matching a given email
      # 
      #  @param email (string) The email identifying the account
      #  If email is null, the first account is considered
      # 
      #  @return (xml.etree.ElementTree.ElementTree) Object representation of the account
      # 
      #  @throws ApiConfAccountNotFoundError If an email is provided but can't be found
      #
      def account(email = nil)
        if accounts.length == 0
          raise Allorails::ApiConfAccountNotFoundError, "No account found in config. You must configure at least one account."
        else
          # if email is null, the first account is considered
          return accounts[accounts.keys.first] if email.nil?
          # find the account corresponding to the email
          return accounts[email] if accounts.has_key?(email)
        end
        # raise ApiConfAccountNotFoundError if email is provided but can't be found
        raise Allorails::ApiConfAccountNotFoundError, "Missing configuration for account `#{email}`"
      end
    
      # supplied options
      def supplied
        @supplied ||= {}
      end
      
      # class methods
      class << self
        
        # accepted options
        def accepted_options
          @options ||= Set.new
        end
        
        # used internally to register a configuration option
        def add_option name, default_value = nil
          # marks the option as accepted
          accepted_options << name
          # defines an accessor method for the option
          define_method(name) do
            if supplied.has_key?(name)
              supplied[name]
            else
              default_value
            end
          end
        end
        
        
      
      end #-- end class << self
      
      # registers configuration options
      add_option :accounts, {}
      add_option :default_hash, 'sha1'
      add_option :default_format, 'json'
      add_option :network_timeout, 20
      add_option :network_protocol, 'http'
      add_option :network_port, 80
      add_option :host, 'api.allopass.com'
      
    end #-- end class Configuration
    
  end #-- end module Core
  
  class << self
    
    @@config = nil
    
    # The global configuration for Allorails
    # generally you would set your configuration options once, after
    # loading the allorails gem.
    #
    #   Allorails.config({
    #     :accounts => {
    #       :your@email.com => {
    #         :api_key => 'API_KEY',
    #         :private_key => 'PRIVATE_KEY'
    #       }
    #     },
    #     :network_port => PORT
    #   })
    #
    def config options = {}
      @@config ||= Core::Configuration.new
      @@config = @@config.with(options) unless options.empty?
      @@config
    end
    
  end
  
end