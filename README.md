# Allorails

Allorails is a Ruby client for Allopass's online payment REST API. It allows Ruby and Rails developers to easily integrate their software with the Allopass online payment platform.

### Setup

Despite the name, Allorails *does not* require Rails, and can be used just like any ordinary Ruby gem:

    gem install allorails

will install the `allorails` gem on your system. You can then `require "allorails"` from your Ruby code, which makes the `Allorails` class available.

**Rails users**, you can simply add the following line to your `Gemfile`

    gem allorails

### Configuration

You can provide configuration options to Allorails by calling `Allorails.config` :

    Allorails.config({
      :accounts => {
        :'your@account.email' => {
          :api_key => 'your-allopass-api-key',
          :private_key => 'your-allopass-private-key'
        }
      }
    })
    
**Rails users**: you can put the above code in an initializer, e.g. `config/initializers/allorails.rb`, or use the `allorails.yml` configuration method explained below.
    
**Multiple accounts** can be set up by adding other email addresses to the `:accounts` hash.

### Usage

Now that the configuration is done, let's start using the API:

    api = Allorails::Api.new
    response = api.get_onetime_pricing({'site_id' => YOUR_SITE_ID, 'country' => 'UK'})
    puts response.creation_date
    
If you have set up multiple accounts, you can choose which one to use by passing the email address to Api.new: `Allorails::Api.new('your@account.email')`

### Rails users: `allorails.yml` configuration file

You can put your configuration options in a yaml file located at `config/allorails.yml`. This file must have the same structure as the standard `database.yml` file found in all Rails applications, i.e. it must include a key for each environment:

    development:
      accounts:
        your@account.email:
          api_key: "YOUR_API_KEY"
          private_key: "YOUR_PRIVATE_KEY" 
      
      # optional settings
      # (the values below are the defaults)
      default_hash: "sha1"
      network_timeout: 20
      network_protocol: "http"
      network_port: 80
      host: "api.allopass.com"

    
    
    
    
### Credits

Allorails is inspired by the Allopass ApiKit for Python written by Pierre Geoffroy and available [here](http://developer.allopass.com/apidoc/kit/python3.1/index.html). 