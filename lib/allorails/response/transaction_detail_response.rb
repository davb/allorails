## Class defining a transaction detail request's response
class Allorails::Response::TransactionDetailResponse < Allorails::Response::ApiMappingResponse

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
  node_reader :price, Allorails::Price

  ## Provides paid price information
  #  @return (Price) paid price information
  node_reader :paid, Allorails::Price

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
    xml.css('partners').map{|c| Allorails::Partner.new(c)}
  end

end