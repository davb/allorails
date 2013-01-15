## Class defining a onetime validate-codes request's response
class Allorails::Response::OnetimeValidateCodesResponse < Allorails::Response::ApiMappingResponse
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
  node_reader :price, Allorails::Price

  ## Provides paid price information
  #  @return (Price) paid price information
  node_reader :paid, Allorails::Price

  ## Provides the validation date
  #  @return (datetime.datetime) validation date
  node_reader :validation_date, DateTime

  ## Provides the product name
  #  @return (string) product name
  node_reader :product_name

  ## Provides the website
  #  @return (Website) website
  node_reader :website, Allorails::Website

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
    xml.css('codes code').map{|c| Allorails::Code.new(c)}
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
    xml.css('partners partner').map{|c| Allorails::Partner.new(c)}
  end

end