source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.7'
# Use postgresql as the database for Active Record
gem 'pg'

gem 'rails_config'
gem 'koala'

gem 'active_attr'

gem 'active_model_serializers'

gem 'interactor', '~> 3.0'

# Google API
gem 'google_places'
gem 'geocoder'

gem 'sidekiq'
gem 'sinatra', '>= 1.3.0', require: nil

# APNS
gem 'houston'

gem 'connection_pool'

gem 'devise'
gem 'doorkeeper'


group :production do
  # Use unicorn as the app server
  gem 'unicorn'
  gem 'newrelic_rpm'
end


# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development

group :development, :test do
  gem 'pry'
  gem 'pry-nav'
  gem 'pry-rails'
end


group :development, :test do
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'shoulda-matchers', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

gem 'syslogger', '~> 1.6.0'

# Use Capistrano for deployment
group :development do
  gem 'capistrano-rails'
  gem 'capistrano-rbenv'
  gem 'capistrano-sidekiq'
end

# Use debugger
# gem 'debugger', group: [:development, :test]

