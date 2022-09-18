require 'pathname'
require 'tsort'

class Updater
  module Js
    INLINED_SRCS = %w[index.js tools/sanitizer.js].freeze
    EXTERNAL_JS = %w[popper.js].freeze

    def update_javascript_assets
      log_status 'Updating javascripts...'
      save_to  = @save_to[:js]
      read_files('js/dist', bootstrap_js_files).each do |name, content|
        save_file("#{save_to}/#{name}", remove_source_mapping_url(content))
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
        save_file path, remove_source_mapping_url(content)
        log_processed path
      end
    end

    def bootstrap_js_files
      @bootstrap_js_files ||= begin
        src_files = get_paths_by_type('js/src', /\.js$/) - INLINED_SRCS
        puts "src_files: #{src_files.inspect}"
        imports = Deps.new
        # Get the imports from the ES6 files to order requires correctly.
        read_files('js/src', src_files).each do |name, content|
          file_imports = content.scan(%r{import *(?:[a-zA-Z]*|\{[a-zA-Z ,]*\}) *from '([\w/.-]+)}).flatten(1).map do |f|
            Pathname.new(name).dirname.join(f.end_with?(".js") ? f : "#{f}.js").cleanpath.to_s
          end.uniq
          imports.add name, *(file_imports - INLINED_SRCS - EXTERNAL_JS)
        end
        imports.tsort
      end
    end

    def remove_source_mapping_url(content)
      content.sub(%r{^//# sourceMappingURL=.*\n?\z}, '')
    end

    class Deps
      include TSort

      def initialize
        @imports = {}
      end

      def add(from, *tos)
        imports = (@imports[from] ||= [])
        imports.push(*tos)
        imports.sort!
      end

      def tsort_each_child(node, &block)
        node_imports = @imports[node]
        if node_imports.nil?
          raise "No imports found for #{node.inspect}\nImports:\n#{@imports.inspect}"
        end
        node_imports.each(&block)
      end

      def tsort_each_node(&block)
        @imports.each_key(&block)
      end
    end
  end
end
