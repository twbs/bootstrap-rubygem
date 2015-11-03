require 'test_helper_rails'

class RailsTest < ActionDispatch::IntegrationTest
  include ::DummyRailsIntegration

  def test_visit_root
    visit root_path
    # ^ will raise on JS errors

    assert_equal 200, page.status_code

    screenshot!
  end

  def test_autoprefixer
    get ActionController::Base.helpers.stylesheet_path('application.css')
    assert_match /-webkit-(?:transition|transform)/, response.body
  end

  def test_precompile
    Dummy::Application.load_tasks
    Rake::Task['assets:precompile'].invoke
  end
end
