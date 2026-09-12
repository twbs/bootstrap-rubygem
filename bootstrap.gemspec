lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bootstrap/version'

Gem::Specification.new do |s|
  s.name     = 'bootstrap'
  s.version  = Bootstrap::VERSION
  s.authors  = ['Twitter, Inc.']
  s.email    = 'glex.spb@gmail.com'
  s.summary  = 'The most popular HTML, CSS, and JavaScript framework for developing responsive, mobile first projects on the web. http://getbootstrap.com'
  s.homepage = 'https://github.com/twbs/bootstrap-rubygem'
  s.license  = 'MIT'

  # Bootstrap 6 requires a Dart Sass engine; dartsass-sprockets needs Ruby 2.6+.
  # Compiling the v6 stylesheets needs a recent Dart Sass (dartsass-sprockets
  # >= 3.1, i.e. Ruby 3.1+) or cssbundling-rails (Sass runs in Node).
  s.required_ruby_version = '>= 2.6'

  # Bootstrap 6 uses @floating-ui/dom (vendored in assets/javascripts) instead
  # of Popper, so there is no longer a popper_js runtime dependency.

  s.add_development_dependency 'rake'

  # Testing dependencies
  s.add_development_dependency 'minitest', '>= 5.14.4', '< 7'
  s.add_development_dependency 'minitest-reporters', '~> 1.4.3'
  s.add_development_dependency 'term-ansicolor'
  # Integration testing (headless browser)
  s.add_development_dependency 'capybara', '>= 2.6.0'
  s.add_development_dependency 'cuprite'
  s.add_development_dependency 'webrick'
  # Dummy Rails app dependencies
  s.add_development_dependency 'railties'
  s.add_development_dependency 'actionpack', '>= 4.1.5'
  s.add_development_dependency 'activesupport', '>= 4.1.5'
  s.add_development_dependency 'json', '>= 1.8.1'
  s.add_development_dependency 'sprockets-rails', '>= 2.3.2'
  s.add_development_dependency 'uglifier'

  s.files      = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- test/*`.split("\n")
end
