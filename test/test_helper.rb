require 'minitest/autorun'
require 'minitest/reporters'
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

require 'active_support/core_ext/kernel/reporting'

Dir['test/support/**/*.rb'].each do |file|
  # strip ^test/ and .rb$
  file = file[5..-4]
  require_relative File.join('.', file)
end

GEM_PATH = File.expand_path('../', File.dirname(__FILE__))

#= Capybara
require 'capybara/cuprite'

browser_path = ENV['CHROMIUM_BIN'] || %w[
  /usr/bin/chromium-browser
  /snap/bin/chromium
  /Applications/Chromium.app/Contents/MacOS/Chromium
  /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome
].find { |path| File.executable?(path) }

Capybara.register_driver :cuprite do |app|
  options = {
      window_size: [1280, 1024]
  }
  options[:browser_path] = browser_path if browser_path
  Capybara::Cuprite::Driver.new(app, options)
end

Capybara.configure do |config|
  config.server = :webrick
  config.app_host = 'http://localhost:7000'
  config.default_driver = :cuprite
  config.javascript_driver = :cuprite
  config.server_port = 7000
  config.default_max_wait_time = 10
end

