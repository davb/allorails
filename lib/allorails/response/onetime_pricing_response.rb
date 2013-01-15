class Allorails::Response::OnetimePricingResponse < Allorails::Response::ApiMappingResponse

  ## Provides the creation date
  #  @return (DateTime) Creation date
  node_reader :creation_date, DateTime

  ## Provides the customer ip
  #  @return (string) customer ip
  node_reader :customer_ip

  ## Provides the customer country
  #  @return (string) customer country
  node_reader :customer_country

  ## Provides the website
  #  @return (Website) website
  node_reader :website, Allorails::Website

  ## Provides the pricepoints by countries
  #  @return (Array) available countries (list of Country object)
  def countries
    xml.css('countries country').map{|c| Allorails::Country.new(c)}
  end

  ## Provides the pricepoints by region
  #  @return (Array) available regions (list of Regions object)
  def regions
    xml.css('countries region').map{|r| ::Allorails::Region.new(r)}
  end

  ## Provides the pricepoints by markets
  #  @return (list) available markets (list of Market object)
  def markets
    xml.css('markets market').map{|m| Allorails::Market.new(m)}
  end

end