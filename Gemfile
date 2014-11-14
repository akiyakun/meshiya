source 'https://rubygems.org'
ruby '2.1.3'

# x.x.x	バージョンを固定
# >= x.x.x	x.x.x以上のバージョンが必要
# >= x.x.x, < y.y.y	x.x.x以上、y.y.y以下のバージョンが必要
# ~> x.0	x.1からx.9は良いが、メインのバージョンがあがるとは不可
# 例えば、3.2は良いが、4.0は不可など

gem 'rails', '4.1.6'
gem 'sprockets', '2.11.0'
# gem 'will_paginate', '3.0.4'
gem 'will_paginate'
# gem 'mislav-will_paginate'

# Use Bootstraps
gem 'bootstrap-sass', '2.3.2.0'
# gem 'bootstrap-will_paginate', '0.0.9'
gem 'bootstrap-will_paginate'

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Use auto creation sample users
gem 'faker', '1.1.2'

group :development, :test do
	gem 'sqlite3'
	gem 'rspec-rails', '~> 2.14.0.rc1'
end

group :test do
	gem 'selenium-webdriver', '2.35.1'
	gem 'capybara', '2.1.0'
	gem 'shoulda-matchers', '~> 2.6.0'
	gem 'factory_girl_rails', '4.2.1'
end

group :production do
	gem 'pg'
	gem 'rails_12factor'
end

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
# gem 'sdoc', '~> 0.4.0',          group: :doc

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development


# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

