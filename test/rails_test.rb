require 'test_helper_rails'

class RailsTest < ActionDispatch::IntegrationTest
  include ::DummyRailsIntegration
  include ::SassEngineSupport

  def test_visit_root
    skip_unless_sass_can_compile_bootstrap!

    visit root_path
    # ^ will raise on JS errors

    assert_equal 200, page.status_code

    screenshot!
  end

  def test_precompile
    skip_unless_sass_can_compile_bootstrap!

    Dummy::Application.load_tasks
    Rake::Task['assets:precompile'].invoke
  end
end
