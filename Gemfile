# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.6.8"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem "rails", "~> 6.1.4", ">= 6.1.4.1"
# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"
# Use Puma as the app server
gem "puma", "~> 5.0"
# Use SCSS for stylesheets
gem "sass-rails", ">= 6"
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem "webpacker", "~> 5.0"
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem "turbolinks", "~> 5"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.7"
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.4.4", require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: %i[mri mingw x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem "web-console", ">= 4.1.0"
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem "rack-mini-profiler", "~> 2.0"
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem "capybara", ">= 3.26"
  gem "selenium-webdriver"
  # Easy installation and use of web drivers to run system tests with browsers
  gem "webdrivers"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

gem "require_all"
gem "simplecov", require: false, group: :test
gem "simplecov-json", :require => false, :group => :test

gem "git"
gem "nokogiri"
gem "http"
gem "pivot_table"
gem "time"
gem "celluloid"

# for ML advisor
gem "kmeans-clusterer"


gem 'codecov', '0.5.1'
gem 'glogin', '0.7.0'
gem 'haml', '5.2.1'
gem 'mail', '2.7.1'
gem 'mocha', '1.11.2', require: false
gem 'octokit', '4.20.0'
gem 'rack', '2.2.3.1'
gem 'rack-test', '1.1.0'
gem 'rake', '13.0.3', require: false
gem 'rubocop', '0.69.0', require: false
gem 'rubocop-rspec', '1.33.0', require: false
gem 'sass', '3.7.4'
gem 'sentry-raven', '3.1.1'
gem 'sprockets', '4.0.2'
gem 'test-unit', '3.4.0', require: false
gem 'xcop', '0.6.2'