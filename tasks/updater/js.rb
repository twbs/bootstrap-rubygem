class Updater
  module Js
    def update_javascript_assets
      log_status 'Updating javascripts...'
      save_to  = @save_to[:js]
      contents = {}
      read_files('js/dist', bootstrap_js_files).each do |name, file|
        contents[name] = file.
            # Remove the source mapping URL comment as this gem does not bundle source maps.
            sub!(%r(^//# sourceMappingURL=#{name}.map\n\z), '') or
            fail "Cannot find source mapping URL to remove in #{name}. Last line: #{file.lines.last.inspect}"
        save_file("#{save_to}/#{name}", file)
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
        gruntfile = get_file(file_url 'Gruntfile.js')
        JSON.parse(/concat:.*?src: (\[[^\]]+\])/m.match(gruntfile)[1].tr("'", '"')).map { |p| p.sub %r(\Ajs/src/), '' }
      end
    end
  end
end
