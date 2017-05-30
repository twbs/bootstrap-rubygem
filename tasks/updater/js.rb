class Updater
  module Js
    def update_javascript_assets
      log_status 'Updating javascripts...'
      save_to  = @save_to[:js]
      read_files('js/dist', bootstrap_js_files).each do |name, content|
        content = content.sub(%r{^//# sourceMappingURL=.*\n?\z}, '')
        save_file("#{save_to}/#{name}", content)
      end
      log_processed "#{bootstrap_js_files * ' '}"

      log_status 'Updating javascript manifest'
      manifest = ''
      bootstrap_js_files.each do |name|
        name = name.gsub(/\.js$/, '')
        manifest << "//= require ./bootstrap/#{name}\n"
      end
      dist_js = read_files('dist/js', %w(bootstrap.js bootstrap.min.js))
      {
          'assets/javascripts/bootstrap-sprockets.js' => manifest,
          'assets/javascripts/bootstrap.js'           => dist_js['bootstrap.js'],
          'assets/javascripts/bootstrap.min.js'       => dist_js['bootstrap.min.js'],
      }.each do |path, content|
        save_file path, content
        log_processed path
      end
    end

    def bootstrap_js_files
      @bootstrap_js_files ||= begin
        package_json = get_file(file_url 'package.json')
        JSON.parse(package_json)['scripts']['js-compile-bundle']
            .match(/shx cat (.*?) \|/)[1].split(/\s+/)
            .map { |p| p.sub %r(\Ajs/src/), '' }
      end
    end
  end
end
