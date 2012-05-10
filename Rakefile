require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('allorails', '0.4.1') do |p|
  p.description    = "Ruby client for the Allopass online payment REST API"
  p.url            = "http://github.com/davb/allorails"
  p.author         = "Davide Bonapersona"
  p.email          = "davide@feeligo.com"
  p.ignore_pattern = ["tmp/*", "script/*"]
  p.development_dependencies = []
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }