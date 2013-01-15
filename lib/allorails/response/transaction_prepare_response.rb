## Class defining a transaction prepare request's response
class Allorails::Response::TransactionPrepareResponse < Allorails::Response::ApiMappingResponse

  ## Provides access type
  #  @return (string) access type
  node_reader :access_type

  ## Provides the transaction id
  #  @return (string) transaction id
  node_reader :transaction_id

  ## Provides the creation date
  #  @return (datetime.datetime) Creation date
  node_reader :creation_date, DateTime

  ## Provides price information
  #  @return (Price) price information
  node_reader :price, Allorails::Price

  ## Provides information about the pricepoint
  #  @return (Pricepoint) pricepoint information
  node_reader :pricepoint, Allorails::Pricepoint

  ## Provides the website
  #  @return (Website) website
  node_reader :website, Allorails::Website

  ## Provides the buy url
  #  @return (string) buy url
  node_reader :buy_url

  ## Provides the checkout button
  #  @return (string) checkout button (html code)
  node_reader :checkout_button

end