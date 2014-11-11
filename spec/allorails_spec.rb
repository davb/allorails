require 'spec_helper'

# test config
YOUR_SITE_ID = 281629
TEST_COUNTRY_CODE = 'FR'
Allorails.config(YAML.load File.read(File.join(File.dirname(__FILE__), 'test-conf.yml')))


## -- RESPONSES --


describe Allorails::Response::ApiResponse do

  it "throws ApiFalseResponseSignatureError if signature not found among headers" do
    
    # with the expected signature in the headers: no error
    lambda {
      Allorails::Response::ApiResponse.new('s', {'x-allopass-response-signature' => ['s']},
        '')._verify
    }.should_not raise_error Allorails::ApiFalseResponseSignatureError
    
    # without the signature: error
    lambda {
      Allorails::Response::ApiResponse.new('signature', {}, '')._verify
    }.should raise_error Allorails::ApiFalseResponseSignatureError
  end
end


describe Allorails::Response::ApiMappingResponse do

  it "throws ApiWrongFormatResponseError if empty body" do
    lambda {
      Allorails::Response::ApiMappingResponse.new('signature', [], '')  
    }.should raise_error(Allorails::ApiWrongFormatResponseError)
  end

  it "throws ApiWrongFormatResponseError if non-XML body" do
    lambda {
      Allorails::Response::ApiMappingResponse.new('signature', [], 'this is not XML')  
    }.should raise_error(Allorails::ApiWrongFormatResponseError)
  end

  it "throws ApiRemoteErrorError if missing code='0' attribute in root element" do
    # without code="0": error
    lambda {
      Allorails::Response::ApiMappingResponse.new('signature', [], '<root></root>')  
    }.should raise_error(Allorails::ApiRemoteErrorError)

    # with code="0": no error
    lambda {
      Allorails::Response::ApiMappingResponse.new('s', {'x-allopass-response-signature' => ['s']},
        '<root code="0"></root>')  
    }.should_not raise_error(Allorails::ApiRemoteErrorError)
  end
end


shared_context "with onetime pricing response" do
  # the response to test  
  let(:response) { Allorails::Api.new.get_onetime_pricing(
    'site_id' => YOUR_SITE_ID,
    'country' => TEST_COUNTRY_CODE
  )}
end


describe Allorails::Response::OnetimePricingResponse do
  include_context "with onetime pricing response"
  

  it "has valid creation_date" do
    response.creation_date.should be_a(DateTime)
  end

  it "has valid customer_ip" do
    response.customer_ip.should be_a(String)
  end

  it "has valid customer_country" do
    response.customer_country.should be_a(String)
  end

  it "has valid website" do
    response.website.should be_a(Allorails::Website)
  end

  it "has valid countries" do
    response.countries.should be_a(Array)
    response.countries.each {|c| c.should be_a(Allorails::Country)}
  end

  it "has valid regions" do
    response.regions.should be_a(Array)
    response.regions.each {|c| c.should be_a(Allorails::Region)}
  end

  it "has valid markets" do
    response.markets.should be_a(Array)
    response.markets.each {|c| c.should be_a(Allorails::Market)}
  end
end


shared_context "with OnetimeValidateCodesResponse" do
  let(:response) { Allorails::Api.new.validate_codes(
    'site_id' => YOUR_SITE_ID,
    'code' => ['X878Z532'],
    'product_name' => 'whatever'
  )}
end


describe Allorails::Response::OnetimeValidateCodesResponse do
  include_context "with OnetimeValidateCodesResponse"

  # the examples below are meaningless if the response fails
  before(:all) do
    if response.nil? || response.status != 0
      raise "OnetimeValidateCodes: the API returned a failure. Please make sure you are testing with valid code"
    end
  end

  it "has valid status" do
    response.status.should be_a(Integer)
  end

  it "has valid status_description" do
    response.status_description.should be_a(String)
  end

  it "has valid access_type" do
    response.access_type.should be_a(String)
  end

  it "has valid transaction_id" do
    response.transaction_id.should be_a(String)
  end

  it "has valid price" do
    response.price.should be_a(Allorails::Price)
  end

  it "has valid paid" do
    response.paid.should be_a(Allorails::Price)
  end

  it "has valid validation_date" do
    response.validation_date.should be_a(DateTime)
  end

  it "has valid product_name" do
    response.product_name.should be_a(String)
  end

  it "has valid website" do
    response.website.should be_a(Allorails::Website)
  end

  it "has valid customer_ip" do
    response.customer_ip.should be_a(String)
  end

  it "has valid customer_country" do
    response.customer_country.should be_a(String)
  end

  it "has valid expected_number_of_codes" do
    response.expected_number_of_codes.should be_a(Integer)
  end

  it "has valid codes" do
    response.codes.should be_a(Array)
    response.codes.each {|c| c.should be_a(Allorails::Code)}
  end

  it "has valid merchant_transaction_id" do
    response.merchant_transaction_id.should be_a(String)
  end

  it "has valid data" do
    response.data.should be_a(String)
  end

  it "has valid affiliate" do
    response.affiliate.should be_a(String)
  end

  it "has valid partners" do
    response.partners.should be_a(Array)
    response.partners.each {|c| c.should be_a(Allorails::Partner)}
  end
end


shared_context "with ProductDetailResponse" do
  let(:product_id){1162361}
  let(:response) do
    Allorails::Api.new.get_product(product_id, {
      'site_id' => YOUR_SITE_ID,
    })
  end
end


describe Allorails::Response::ProductDetailResponse do
  include_context "with ProductDetailResponse"

  # the examples below are meaningless if the request fails
  before(:all) do
    if response.nil?
      raise "ProductDetail: the API returned a failure. Please make sure you are testing with valid product id"
    end
  end

  it "has valid product id" do
    response.id.should eq product_id
  end
end


describe Allorails::Response::OnetimeButtonResponse do
  pending "TODO: write spec"
end


describe Allorails::Response::TransactionDetailResponse do
  pending "TODO: write spec"
end


describe Allorails::Response::TransactionPrepareResponse do
  pending "TODO: write spec"
end


## -- MODELS --

describe Allorails::Website do
  include_context "with onetime pricing response"
  let(:website) { response.website }

  it "has integer id" do
    website.id.should be_a(Integer)
  end

  it "has string name" do
    website.name.should be_a(String)
  end

  it "has string url" do
    website.url.should be_a(String)
  end

  it "has boolean audience_restricted?" do
    website.audience_restricted?.should eq(!!website.audience_restricted?)
  end

  it "has string category" do
    website.category.should be_a(String)
  end
end


describe Allorails::Country do
  include_context "with onetime pricing response"
  let(:country) { response.countries.first }

  before(:all) do
    pending "response does not have any countries" if country.nil?
  end 

  it "has string code" do
    country.code.should be_a(String)
    country.code.length.should eq(2)
  end

  it "has string name" do
    country.name.should be_a(String)
  end
end


describe Allorails::Region do
  include_context "with onetime pricing response"
  let(:region) { response.regions.first }

  before(:all) do
    pending "response does not have any regions" if region.nil?
  end

  it "has string name" do
    region.name.should be_a(String)
  end

  it "has valid countries" do
    region.countries.should be_a(Array)
    region.countries.each {|c| c.should be_a(Allorails::Country)}
  end  
end


shared_context "with market" do
  include_context "with onetime pricing response"
  let(:market) { response.markets.first }
end


describe Allorails::Market do
  include_context "with market"
  let(:market) { response.markets.first }

  before do
    pending "response does not have any markets" if market.nil?
  end

  it "has string country_code" do
    market.country_code.should be_a(String)
  end

  it "has string country name" do
    market.country.should be_a(String)
  end

  it "has valid pricepoints" do
    market.pricepoints.should be_a(Array)
    market.pricepoints.each {|pp| pp.should be_a(Allorails::Pricepoint)}
  end
end


shared_context "with pricepoint" do
  include_context "with market"
  let(:pricepoint) { market ? market.pricepoints.first : nil } 
end


describe Allorails::Pricepoint do
  include_context "with pricepoint"

  before(:all) do
    pending "market does not have any pricepoints" if pricepoint.nil?
  end

  it "has integer id" do
    pricepoint.id.should be_a(Integer)
  end

  it "has string type" do
    pricepoint.type.should be_a(String)
  end

  it "has string country_code" do
    pricepoint.country_code.should be_a(String)
  end

  it "has valid price" do
    pricepoint.price.should be_a(Allorails::Price)
  end

  it "has valid payout" do
    pricepoint.payout.should be_a(Allorails::Payout)
  end

  it "has string buy_url" do
    pricepoint.buy_url.should be_a(String)
    pricepoint.buy_url[0,4].should eq('http')
  end

  it "has valid phone numbers" do
    pricepoint.phone_numbers.should be_a(Array)
    pricepoint.phone_numbers.each {|pn| pn.should be_a(Allorails::PhoneNumber)}
  end

  it "has valid keywords" do
    pricepoint.keywords.should be_a(Array)
    pricepoint.keywords.each {|kw| kw.should be_a(Allorails::Keyword)}
  end    

  it "has string description" do
    pricepoint.description.should be_a(String)
  end

end


shared_examples "an amount of money" do
  it "has string currency, length=3" do
    amount_of_money.currency.should be_a(String)
    amount_of_money.currency.length.should eq(3)
  end

  it "has float amount" do
    amount_of_money.amount.should be_a(Float)
  end

  it "has float exchange" do
    amount_of_money.exchange.should be_a(Float)
  end

  it "has string reference currency, length=3" do
    amount_of_money.currency.should be_a(String)
    amount_of_money.currency.length.should eq(3)
  end

  it "has float reference_amount" do
    amount_of_money.reference_amount.should be_a(Float)
  end
end


describe Allorails::Price do
  include_context "with pricepoint"
  let(:price) { pricepoint.price }

  before(:all) do
    pending "price missing from pricepoint" if price.nil?
  end

  it_behaves_like "an amount of money" do
    let(:amount_of_money) { price }
  end
end


describe Allorails::Payout do
  include_context "with pricepoint"
  let(:payout) { pricepoint.payout }

  before(:all) do
    pending "payout missing from pricepoint" if payout.nil?
  end

  it_behaves_like "an amount of money" do
    let(:amount_of_money) { payout }
  end
end


describe Allorails::PhoneNumber do
  include_context "with pricepoint"
  let(:phone_number) { pricepoint.phone_numbers.first }

  before(:all) do
    pending "pricepoint does not have any phone_numbers" if phone_number.nil?
  end

  it "has string value" do
    phone_number.value.should be_a(String)
  end

  it "has string description" do
    phone_number.description.should be_a(String)
  end
end


describe Allorails::Keyword do
  include_context "with market"
  let(:pricepoint) { market ? market.pricepoints.keep_if{|pp| !pp.keywords.empty?}.first : nil } 
  let(:keyword) { pricepoint.keywords.first }

  before(:all) do
    pending "pricepoint does not have any keywords" if keyword.nil?
  end

  it "has string name" do
    keyword.name.should be_a(String)
  end

  it "has string shortcode" do
    keyword.shortcode.should be_a(String)
  end

  it "has string operators" do
    keyword.operators.should be_a(String)
  end

  it "has integer number_billed_messages" do
    keyword.number_billed_messages.should be_a(Integer)
  end

  it "has string description" do
    keyword.description.should be_a(String)
  end
end


describe Allorails::Partner do
  include_context "with OnetimeValidateCodesResponse"
  let(:partner) { response.partners.first }

  before(:all) do
    pending "response does not have any partners" if partner.nil?
  end

  it "has integer id" do
    partner.id.should be_a(Integer)
  end

  it "has float share" do
    partner.share.should be_a(Float)
  end

  it "has int or nil map" do
    partner.map.should be_nil_or_a(Integer)
  end
end


describe Allorails::Code do
  include_context "with OnetimeValidateCodesResponse"
  let(:code) { response.codes.first }

  before(:all) do
    pending "response does not have any codes" if code.nil?
  end

  it "has string value" do
    code.value.should be_a(String)
  end

  it "has valid price" do
    code.price.should be_a(Allorails::Price)
  end

  it "has valid paid price" do
    code.paid.should be_a(Allorails::Price)
  end

  it "has valid payout" do
    code.payout.should be_a(Allorails::Payout)
  end
end

