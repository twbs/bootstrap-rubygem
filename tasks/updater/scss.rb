class Updater
  module Scss
    def update_scss_assets
      log_status 'Updating scss...'
      save_to = @save_to[:scss]
      contents = {}
      bootstrap_scss_files = get_paths_by_type('scss', /\.scss$/).reject { |p| p.start_with?('tests/') }
      read_files('scss', bootstrap_scss_files).each do |name, file|
        contents[name] = file
        save_file("#{save_to}/#{name}", file)
      end
      log_processed "#{bootstrap_scss_files * ' '}"

      log_status 'Updating scss main file'
      # Bootstrap 6 exposes a single `bootstrap` entry point. Make it a partial
      # and move it up a level to clearly mark it as the entry point, rewriting
      # its `@use`/`@forward` paths to account for the move.
      from = "#{save_to}/bootstrap.scss"
      to   = "#{save_to}/../_bootstrap.scss"
      FileUtils.mv from, to
      File.write to, File.read(to).gsub(/ "/, ' "bootstrap/')
    end
  end
end
