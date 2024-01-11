# frozen_string_literal: true

require 'autoprefixer-rails'

SASS_ENGINES = ['dartsass-sprockets', 'sassc-rails', 'dartsass-rails', 'cssbundling-rails']

engine_loaded = SASS_ENGINES.any? do |engine|
  begin
    require engine
    true
  rescue LoadError
    false
  end
end

unless engine_loaded
  raise LoadError.new("bootstrap-rubygem requires a Sass engine. Please add one of the following to your dependencies: #{SASS_ENGINES.join(', ')}")
end

module Bootstrap
  module Rails
    class Engine < ::Rails::Engine
      initializer 'bootstrap.assets' do |app|
        %w(stylesheets javascripts).each do |sub|
          app.config.assets.paths << root.join('assets', sub).to_s
        end
      end
    end
  end
end
