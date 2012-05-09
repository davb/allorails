# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "allorails"
  s.version = "0.4.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Davide Bonapersona"]
  s.date = "2012-05-09"
  s.description = "Ruby client for the Allopass online payment REST API"
  s.email = "davide@feeligo.com"
  s.extra_rdoc_files = ["README.md", "lib/allorails.rb", "lib/allorails/api/api.rb", "lib/allorails/core.rb", "lib/allorails/errors/errors.rb", "lib/allorails/rails.rb", "lib/allorails/request/request.rb", "lib/allorails/response/model.rb", "lib/allorails/response/response.rb"]
  s.files = ["README.md", "Rakefile", "allorails.gemspec", "init.rb", "lib/allorails.rb", "lib/allorails/api/api.rb", "lib/allorails/core.rb", "lib/allorails/errors/errors.rb", "lib/allorails/rails.rb", "lib/allorails/request/request.rb", "lib/allorails/response/model.rb", "lib/allorails/response/response.rb", "test/allorails_spec.rb", "test/test-conf-sample.yml", "test/test-conf.yml", "Manifest"]
  s.homepage = "http://github.com/davb/allorails"
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Allorails", "--main", "README.md"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "allorails"
  s.rubygems_version = "1.8.21"
  s.summary = "Ruby client for the Allopass online payment REST API"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
