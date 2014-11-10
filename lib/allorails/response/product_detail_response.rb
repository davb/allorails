## Class defining a product detail request's response
class Allorails::Response::ProductDetailResponse < Allorails::Response::ApiMappingResponse

  ## Provides the product id
  #  @return (int) product id
  node_reader :id, Integer

  ## Provides the product key
  #  @return (string) product key
  node_reader :key

  ## Provides access type
  #  @return (string) access type
  node_reader :access_type

  ## Provides the creation date
  #  @return (datetime.datetime) Creation date
  node_reader :creation_date, DateTime

  ## Provides the product name
  #  @return (string) product name
  node_reader :name

  ## Provides the website
  #  @return (Website) website
  node_reader :website, Allorails::Website

  ## Provides the expected number of codes
  #  @return (int) expected number of codes
  node_reader :expected_number_of_codes, Integer

  ## Provides the purchase url
  #  @return (string) purchase url
  node_reader :purchase_url

  ## Provides the forward url
  #  @return (string) forward url
  node_reader :forward_url

  ## Provides the error url
  #  @return (string) error url
  node_reader :error_url

  ## Provides the notification url
  #  @return (string) notification url
  node_reader :notification_url

end


