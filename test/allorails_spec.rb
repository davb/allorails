require 'allorails'
require 'yaml'

# load Allorails configuration options for testing
#
# to be able to run these tests, create a test/test-conf.yml file,
# based on test/test-conf-sample.yml
# but using your own API credentials
Allorails.config(YAML.load File.read(File.join(File.dirname(__FILE__), 'test-conf.yml')))


# some additional parameters for the tests
YOUR_SITE_ID = 281629
TEST_COUNTRY_CODE = 'UK'


# run the tests

describe Allorails::Request::ApiRequest, "#init" do
  it "starts" do
    req = Allorails::Request::ApiRequest.new(params = {}, mapping = true, email_account = nil)
    req.should_not be_nil
  end
end

describe Allorails::Api, "#init" do
  it "initializes with email=nil" do
    api = Allorails::Api.new
  end
end

describe Allorails::Api, "#get_onetime_pricing" do
  api = Allorails::Api.new
  it "returns a valid response" do
    resp = api.get_onetime_pricing({'site_id' => YOUR_SITE_ID, 'country' => TEST_COUNTRY_CODE})
    resp.to_s.should_not be_nil
    
    resp.creation_date.is_a?(DateTime).should be_true
    resp.website.is_a?(Allorails::Website).should be_true
    resp.regions.is_a?(Array).should be_true
    resp.regions.each do |reg|
      reg.is_a?(Allorails::Region).should be_true
      reg.countries.is_a?(Array).should be_true
      reg.countries.each do |ctry|
        ctry.is_a?(Allorails::Country).should be_true
        (ctry.code.length > 0).should be_true
      end
    end
    
    resp.markets.is_a?(Array).should be_true
    resp.markets.each do |m|
      m.is_a?(Allorails::Market).should be_true
      m.country_code.is_a?(String).should be_true
      m.country.is_a?(String).should be_true
      m.pricepoints.is_a?(Array).should be_true
      m.pricepoints.each do |pp|
        pp.is_a?(Allorails::Pricepoint).should be_true
        pp.price.is_a?(Allorails::Price).should be_true
        pp.payout.is_a?(Allorails::Payout).should be_true
        
        [pp.price, pp.payout].each do |ppp|
          ppp.currency.is_a?(String).should be_true
          ppp.amount.is_a?(Float).should be_true
          ppp.exchange.is_a?(Float).should be_true
          ppp.reference_currency.is_a?(String).should be_true
          ppp.reference_amount.is_a?(Float).should be_true
        end
        
      end
    end
  end
  it "works with symbol keys and values" do
    resp = api.get_onetime_pricing({:site_id => YOUR_SITE_ID, :country => TEST_COUNTRY_CODE.to_sym})
    resp.creation_date.is_a?(DateTime).should be_true
  end
end

describe Allorails::Api, "#create_discrete_button" do
  api = Allorails::Api.new
  resp = api.create_discrete_button({
    'site_id' => YOUR_SITE_ID,
    'product_name' => 'TEST-DISCRETE-BUTTON',
    'forward_url' => 'http://any-test.url/is?good',
    'price_mode' => 'price',
    'amount' => 0.99,
    'price_policy' => 'high-preferred',
    'reference_currency' => 'EUR'
  })
  it "returns a valid response" do
    resp.to_s.should_not be_nil
    resp.is_a?(Allorails::Response::OnetimeButtonResponse).should be_true
    (resp.json).should_not be_nil
    # puts resp.json.inspect #DEBUG
    resp.button_id.should_not be_nil
    resp.website.is_a?(Allorails::Website).should be_true
  end
end

describe Allorails::Api, "#validate_codes" do
  api = Allorails::Api.new
  resp = api.validate_codes(
    'site_id' => YOUR_SITE_ID,
    'code' => ['X226658Z'],
    'product_name' => 'zeproduct'
  )
  it "returns a valid response" do
    resp.to_s.should_not be_nil
    resp.is_a?(Allorails::Response::OnetimeValidateCodesResponse).should be_true
    (resp.json).should_not be_nil
    #puts resp.json.inspect #DEBUG
  end
end