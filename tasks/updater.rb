# coding: utf-8

require 'open-uri'
require 'json'
require 'strscan'
require 'forwardable'
require 'term/ansicolor'
require 'fileutils'

require_relative 'updater/scss'
require_relative 'updater/js'
require_relative 'updater/logger'
require_relative 'updater/network'

class Updater
  extend Forwardable
  include Network
  include Js
  include Scss

  def initialize(repo: 'twbs/bootstrap', branch: 'main', save_to: {}, cache_path: 'tmp/bootstrap-cache')
    @logger     = Logger.new
    @repo       = repo
    @branch     = branch || 'main'
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
    store_version
  end

  def save_file(path, content, mode='w')
    dir = File.dirname(path)
    FileUtils.mkdir_p(dir) unless File.directory?(dir)
    File.open(path, mode) { |file| file.write(content) }
  end

  def upstream_version
    @upstream_version ||= get_json(file_url 'package.json')['version']
  end

  # Update version.rb file with BOOTSTRAP_SHA
  def store_version
    path    = 'lib/bootstrap/version.rb'
    content = File.read(path).sub(/BOOTSTRAP_SHA\s*=\s*['"][^'"]*['"]/, "BOOTSTRAP_SHA = '#@branch_sha'")
    File.open(path, 'w') { |f| f.write(content) }
  end
end
