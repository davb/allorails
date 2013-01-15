require 'rubygems'
require 'bundler/setup'

require 'allorails'

RSpec.configure do |config|
  # some (optional) config here
end

# custom matchers
RSpec::Matchers.define :be_nil_or_a do |type|
  match do |actual|
    actual.nil? || actual.is_a?(type)
  end
end