lib_path = File.join(File.dirname(__FILE__), 'lib')
$:.unshift(lib_path) unless $:.include?(lib_path)

require 'rake/testtask'
Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = true
end

desc 'Dumps output to a CSS file for testing'
task :debug do
  require 'sass'
  require './lib/bootstrap'
  require 'term/ansicolor'
  path = Bootstrap.stylesheets_path
  %w(_bootstrap _bootstrap-flex _bootstrap-reboot _bootstrap-grid).each do |file|
    engine = Sass::Engine.for_file("#{path}/#{file}.scss", syntax: :scss, load_paths: [path])
    out = File.join('tmp', "#{file[1..-1]}.css")
    File.write(out, engine.render)
    $stderr.puts Term::ANSIColor.green "Compiled #{out}"
  end
end

desc 'Update bootstrap from upstream'
task :update, :branch do |t, args|
  require './tasks/updater'
  Updater.new(branch: args[:branch]).update_bootstrap
end

desc 'Start a dummy Rails app server'
task :rails_server do
  require 'rack'
  require 'term/ansicolor'
  port = ENV['PORT'] || 9292
  puts %Q(Starting on #{Term::ANSIColor.cyan "http://localhost:#{port}"})
  Rack::Server.start(
    config: 'test/dummy_rails/config.ru',
    Port: port)
end

task default: :test
