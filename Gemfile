# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

# All the gems not in a group will always be installed:
#   http://bundler.io/v1.6/groups.html#grouping-your-dependencies
gem 'activerecord-session_store' # Store session details in database
gem 'bootstrap-sass', '~> 3.3.7' # Use Bootstrap for styling
gem 'bootstrap_form'
gem 'devise' # Use devise with LDAP for authentication
gem 'devise_ldap_authenticatable', github: 'sanger/devise_ldap_authenticatable'
gem 'jbuilder', '~> 2.5' # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jquery-rails'
gem 'jwt' # JWTs to send on to the forward server
gem 'launchy'
gem 'lograge'
gem 'logstash-event'
gem 'logstash-logger'
gem 'net-ldap'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.7'
gem 'rails', '~> 5.1.4'
gem 'request_store'
gem 'sass-rails', '~> 5.0' # Use SCSS for stylesheets
gem 'health_check'

###
# Groups
###
group :development, :test do
  gem 'byebug', platforms: :mri # Call 'byebug' to stop execution and get a debugger console
  gem 'capybara', '~> 2.13' # Adds support for Capybara system testing and selenium driver
  gem 'factory_bot_rails'
  gem 'rspec-rails', '~> 3.6'
  gem 'selenium-webdriver'
end

group :development do
  gem 'brakeman', require: false
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring' # Spring speeds up development by keeping your application running in the background
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0' # Access an IRB console on exception pages
end

group :test do
  gem 'rubycritic'
  gem 'simplecov', require: false
  gem 'simplecov-rcov'
end
