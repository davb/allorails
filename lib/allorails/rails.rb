require 'yaml'

module Allorails
  
  if Object.const_defined?(:Rails) and Rails.const_defined?(:Railtie)
    
    class Railtie < Rails::Railtie
      
      initializer "allorails.initialize" do |app|
        Allorails::Rails.setup
      end
      
    end
    
  end
  
  
  module Rails
    
    def self.setup
      load_yaml_config
      #log_to_rails_logger
      nil
    end
    
    # Loads Allorails configuration from +RAILS_ROOT/config/allorails.yml+
    #
    # TODO: this configuration file is optional, you can instead use Ruby
    # to configure Allorails inside an initializer
    # (e.g. +RAILS_ROOT/config/initializers/allorails.rb)
    #
    # If you use the yaml configuration file, it should include one section for
    # each Rails environment:
    #
    #  development:
    #    api_key: YOUR_API_KEY
    #    secret_key: YOUR_SECRET_KEY
    #
    #  production:
    #    api_key: YOUR_API_KEY
    #    secret_key: YOUR_SECRET_KEY
    # 
    # ERB tags are allowed inside the yaml file: you can do things like
    #    api_key: <%= read_from_somewhere_else %>
    #
    def self.load_yaml_config
      
      path = Pathname.new("#{rails_root}/config/allorails.yml")
      
      if File.exists?(path)
        cfg = YAML::load(ERB.new(File.read(path)).result)
        unless cfg[rails_env]
          raise "config/allorails.yml is missing a section for `#{rails_env}`"
        end
        Allorails.config(cfg[rails_env])
      end
      
    end
    
  end
  
end