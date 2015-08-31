source 'https://rubygems.org'

gemspec

# Compass for the dummy app
gem 'compass', require: false

group :development do
  gem 'term-ansicolor'
  source 'https://rails-assets.org' do
    gem 'rails-assets-tether', '>= 1.1.0'
  end
end

group :debug do
  gem 'byebug', platforms: [:mri_21, :mri_22], require: false
end
