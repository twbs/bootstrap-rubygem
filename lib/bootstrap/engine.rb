# frozen_string_literal: true

require 'autoprefixer-rails'
begin
  require 'dartsass-sprockets'
rescue LoadError
  require 'sassc-rails'
rescue LoadError
  raise LoadError.new("bootstrap-rubygem requires a Sass engine. Please add dartsass-sprockets or sassc-rails to your dependencies.")
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
