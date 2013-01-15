## Class defining a onetime button request's response
class Allorails::Response::OnetimeButtonResponse < Allorails::Response::ApiMappingResponse

  ## Provides access type
  #  @return (string) access type
  node_reader :access_type

  ## Provides the button id
  #  @return (string) button id
  node_reader :button_id

  ## Provides the creation date
  #  @return (datetime.datetime) Creation date
  node_reader :creation_date, DateTime

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