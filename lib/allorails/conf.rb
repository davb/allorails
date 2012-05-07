require 'singleton'
require 'yaml'

module Allorails
  
  class Conf
    # Singleton pattern : use Conf.instance to instantiate
    include Singleton
    
    # relative path of the configuration file
    FILE_PATH = '../../conf/conf.yml'
    
    # loads config from YAML file and checks it
    def initialize
      _load_file
      _check_file
    end
    
    ## Internal method processing configuration file loading
    #
    # @throws ApiConfFileMissingError If local API configuration file doesn't exist
    #
    # @throws ApiConfFileCorruptedError If local API configuration file doensn't contain valid XML
    def _load_file
      path = File.join(File.dirname(__FILE__), Conf::FILE_PATH)
      # ensure the file exists
      raise Allorails::ApiConfFileMissingError unless File.exists?(path)
      # parse and read the YAML file and store contents
      begin
        @config = YAML.load File.read(path)
      rescue ArgumentError => e
        raise Allorails::ApiConfFileCorruptedError
      end
    end
    
    ## Internal method processing configuration file checking
    #
    #  @throws ApiConfFileMissingSectionError If local API configuration file doesn't contain every required sections

    REQUIRED_SECTIONS = ['accounts', 'default_hash', 'default_format', 'network_timeout',
      'network_protocol', 'network_port', 'host']
      
    def _check_file
      Conf::REQUIRED_SECTIONS.each do |required_section|
        raise Allorails::ApiConfFileMissingSectionError unless @config.has_key?(required_section)
      end
    end
    
    ## Returns the API key
    #
    #  @param email (string) The email account from which retrieve the API key
    #  If email isn't provided or null, the first account is considered
    #
    #  @return (string) The public API key
    def api_key(email = nil)
      _retrieve_account(email)['api_key']
    end
    
    ## Returns the private key
    # 
    #  @param email (string) The email account from which retrieve the private key
    #  If email isn't provided or null, the first account is considered
    # 
    #  @return (string) The private API key
    def private_key(email = nil)
      _retrieve_account(email)['private_key']
    end
    
    ## Returns the account matching a given email
    # 
    #  @param email (string) The email identifying the account
    #  If email is null, the first account is considered
    # 
    #  @return (xml.etree.ElementTree.ElementTree) Object representation of the account
    # 
    #  @throws ApiConfAccountNotFoundError If an email is provided but can't be found
    def _retrieve_account(email = nil)
      accounts = @config['accounts']
      
      if accounts.length > 0
        # if email is null, the first account is considered
        return accounts[accounts.keys.first] if email.nil?
      
        # find the account corresponding to the email
        return accounts[email] if accounts.has_key?(email)
      end
      
      # raise ApiConfAccountNotFoundError if email is provided but can't be found
      raise Allorails::ApiConfAccountNotFoundError
    end
  
    ## Returns the default response format
    #
    #  @return (string) The response format
    def default_format
      @config['default_format']
    end

    ## Returns the API hostname
    #
    #  @return (string) The API hostname
    def host
      @config['host']
    end

    ## Return the default hash method
    #
    #  @return (string) The default hash method
    def default_hash
      @config['default_hash']
    end
    
    ## Returns the network timeout delay
    #
    #  @return (string) The network timeout delay
    def network_timeout
      @config['network_timeout']
    end
    
    ## Returns the network protocol
    #
    #  @return (string) The network protocol
    def network_protocol
      @config['network_protocol']
    end
    
    ## Returns the network port
    #
    #  @return (string) The network port
    def network_port
      @config['network_port']
    end
        
  end
  
end