require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('allorails', '0.5.3') do |p|
  p.description    = "Ruby/Rails client for the Allopass online payment API"
  p.url            = "http://github.com/davb/allorails"
  p.author         = "Davide Bonapersona"
  p.email          = "davide@feeligo.com"
  p.ignore_pattern = ["tmp/*", "script/*", "spec/*"]
  p.development_dependencies = []
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }
