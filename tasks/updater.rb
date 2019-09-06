# coding: utf-8

require 'open-uri'
require 'json'
require 'strscan'
require 'forwardable'
require 'term/ansicolor'
require 'fileutils'
require 'digest'

require_relative 'updater/scss'
require_relative 'updater/js'
require_relative 'updater/logger'
require_relative 'updater/network'

class Updater
  extend Forwardable
  include Network
  include Js
  include Scss

  def initialize(repo: 'twbs/bootstrap', branch: 'master', save_to: {}, cache_path: 'tmp/bootstrap-cache')
    @logger     = Logger.new
    @repo       = repo
    @branch     = branch || 'master'
    @branch_sha = get_branch_sha
    @cache_path = cache_path
    @repo_url   = "https://github.com/#@repo"
    @save_to    = {
        js:    'assets/javascripts/bootstrap',
        scss:  'assets/stylesheets/bootstrap'}.merge(save_to)
  end

  def_delegators :@logger, :log, :log_status, :log_processing, :log_transform, :log_file_info, :log_processed, :log_http_get_file, :log_http_get_files, :silence_log

  def update_bootstrap
    log_status 'Updating Bootstrap'
    puts " repo   : #@repo_url"
    puts " branch : #@branch_sha #@repo_url/tree/#@branch"
    puts " save to: #{@save_to.to_json}"
    puts " twbs cache: #{@cache_path}"
    puts '-' * 60

    FileUtils.rm_rf('assets')
    @save_to.each { |_, v| FileUtils.mkdir_p(v) }

    update_scss_assets
    update_javascript_assets
    store_metadata
  end

  def save_file(path, content, mode='w')
    dir = File.dirname(path)
    FileUtils.mkdir_p(dir) unless File.directory?(dir)
    File.open(path, mode) { |file| file.write(content) }
  end

  def upstream_version
    @upstream_version ||= get_json(file_url 'package.json')['version']
  end

  def store_metadata
    integrity_lines = read_files('dist/js', %w(bootstrap.min.js bootstrap.bundle.min.js)).
      merge(read_files('dist/css', %w(bootstrap.min.css))).
      transform_values { |content| "sha384-#{Digest::SHA384.base64digest(content)}" }.
      map { |filename, integrity| "    #{filename.inspect} => #{integrity.inspect}," }

    File.write("lib/bootstrap/vendor.rb", <<~RUBY)
      # frozen_string_literal: true

      module Bootstrap
        BOOTSTRAP_SHA    = #{@branch_sha.to_s.inspect}
        VENDOR_VERSION   = #{upstream_version.to_s.inspect}
        VENDOR_INTEGRITY = {
      #{integrity_lines.join("\n")}
        }
      end
    RUBY
  end
end
