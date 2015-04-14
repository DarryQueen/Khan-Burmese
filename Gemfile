source 'https://rubygems.org'

gem 'rails', '3.2.16'
gem 'rake'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# Use SQLite locally only:
group :development, :test do
  gem 'sqlite3'
  gem 'database_cleaner'
  gem 'cucumber-rails', :require => false
  gem 'rspec-rails', '~> 2.14.0'
  gem 'selenium-webdriver'
  gem 'simplecov'
  gem 'factory_girl_rails', '~> 4.0'
end

# Use PG on Heroku:
group :production do
  gem 'pg'
end

# Authorization gems:
gem 'devise'
gem 'cancancan', '~> 1.10'
gem 'rails_admin', :git => 'git://github.com/sferik/rails_admin.git', :branch => 'rails-3.x'

gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'

gem 'roadie'
gem 'roadie-rails'

# Handle API secrets:
gem 'figaro'

# Categorization:
gem 'acts-as-taggable-on', '~> 3.4'
gem 'rails3-jquery-autocomplete'

# In-place editing:
gem 'rest_in_place'

# Voting:
gem 'acts_as_votable', '~> 0.10.0'

# File uploading:
gem 'paperclip', '~> 3.5'
gem 'paperclip-dropbox', '>= 1.1.7'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
