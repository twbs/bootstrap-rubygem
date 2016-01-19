require 'capybara/dsl'
require 'fileutils'
module DummyRailsIntegration
  include Capybara::DSL

  def setup
    super
    cleanup_dummy_rails_files
  end

  def teardown
    super
    cleanup_dummy_rails_files
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end

  def screenshot!
    path = "tmp/#{name}.png"
    page.driver.render(File.join(GEM_PATH, path), full: true)
    STDERR.puts "Screenshot saved to #{path}"
  end

  private
  def cleanup_dummy_rails_files
    FileUtils.rm_rf('test/dummy_rails/tmp/cache', secure: true)
    FileUtils.rm Dir.glob('test/dummy_rails/public/assets/{.[^\.]*,*}')
  end
end
