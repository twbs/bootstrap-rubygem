# frozen_string_literal: true

# Smoke-tests the Bootstrap 6 ES-module JavaScript in a real headless browser,
# the same way an importmaps-based app consumes it. Two delivery paths are
# covered:
#
#   1. The self-contained `bootstrap.bundle.min.js` (inlines @floating-ui/dom and
#      vanilla-calendar-pro) loaded with NO importmap pins -- the recommended path.
#   2. An individual component module (`bootstrap/tooltip.js`) resolving the bare
#      `@floating-ui/dom` specifier to the gem's vendored `floating-ui.js`.
#
# Each path imports a tooltip (positioned via @floating-ui/dom) and asserts the
# component instantiates and that Floating UI actually placed the tooltip.
# Independent of Rails/Sprockets.

require 'minitest/autorun'
require 'webrick'
require 'ferrum'
require 'fileutils'
require 'tmpdir'

class JavascriptTest < Minitest::Test
  # Resolve the path directly rather than `require 'bootstrap'`: loading the gem
  # here would run `Bootstrap.load!` before the dummy Rails app boots and, under
  # random test order, prevent the Rails engine from registering its asset paths.
  JS_DIR = File.expand_path('../assets/javascripts', __dir__)

  def test_self_contained_bundle_needs_no_pins
    # The bundle inlines its dependencies, so no importmap is required at all.
    assert_tooltip_works(<<~HTML)
      <!doctype html><html><head><meta charset="utf-8"></head><body>
        <button id="btn" data-bs-toggle="tooltip" title="Bundled v6">Button</button>
        <script type="module">
          #{tooltip_probe('/bootstrap.bundle.min.js', 'Tooltip')}
        </script>
      </body></html>
    HTML
  end

  def test_module_resolves_vendored_floating_ui
    # The lean component module resolves the bare @floating-ui/dom specifier to
    # the gem's vendored build via an importmap.
    assert_tooltip_works(<<~HTML)
      <!doctype html><html><head><meta charset="utf-8">
        <script type="importmap">
          { "imports": { "@floating-ui/dom": "/floating-ui.js" } }
        </script>
      </head><body>
        <button id="btn" data-bs-toggle="tooltip" title="Vendored Floating UI">Button</button>
        <script type="module">
          #{tooltip_probe('/bootstrap/tooltip.js', 'default')}
        </script>
      </body></html>
    HTML
  end

  private

  # JS that imports a tooltip class, shows a tooltip, and records the outcome on
  # the <body> dataset for the Ruby side to read.
  def tooltip_probe(module_path, export)
    <<~JS
      document.body.dataset.status = "loading";
      try {
        const Tooltip = (await import("#{module_path}")).#{export};
        const tip = new Tooltip(document.getElementById("btn"));
        tip.show(); // positions via @floating-ui/dom computePosition()
        const el = document.querySelector(".tooltip");
        document.body.dataset.status = (typeof tip.show === "function" && el) ? "ok" : "fail";
      } catch (e) {
        document.body.dataset.status = "error: " + (e && e.message || e);
      }
    JS
  end

  def assert_tooltip_works(html)
    docroot = serve_assets(html)
    port    = start_server(docroot)
    browser = new_browser
    browser.go_to("http://127.0.0.1:#{port}/index.html")

    status = nil
    60.times do
      status = browser.evaluate("document.body.dataset.status")
      break if status && status != 'loading'
      sleep 0.1
    end
    refute_nil status, 'ES module never executed in the browser'
    assert_equal 'ok', status, "Bootstrap 6 ESM tooltip failed: #{status}"

    # @floating-ui/dom's computePosition() is async; poll for the inline left/top
    # px it writes onto the rendered tooltip element.
    style = ''
    positioned = false
    30.times do
      style = browser.evaluate(
        "(document.querySelector('.tooltip') || {getAttribute: () => ''}).getAttribute('style') || ''"
      ).to_s
      if style =~ /left:\s*[\d.]+px/ && style =~ /top:\s*[\d.]+px/
        positioned = true
        break
      end
      sleep 0.1
    end
    assert positioned, "@floating-ui/dom did not position the tooltip (style=#{style.inspect})"
  ensure
    browser&.quit
    @server&.shutdown
  end

  def serve_assets(index_html)
    docroot = File.join(Dir.tmpdir, "bootstrap-js-test-#{Process.pid}-#{rand(1 << 20)}")
    FileUtils.rm_rf(docroot)
    FileUtils.mkdir_p(docroot)
    FileUtils.cp_r(File.join(JS_DIR, '.'), docroot)
    File.write(File.join(docroot, 'index.html'), index_html)
    docroot
  end

  def start_server(docroot)
    @server = WEBrick::HTTPServer.new(
      Port: 0,
      DocumentRoot: docroot,
      Logger: WEBrick::Log.new(File::NULL),
      AccessLog: []
    )
    # Ensure JS is served with a module-compatible MIME type.
    @server.config[:MimeTypes]['js'] = 'text/javascript'
    port = @server.config[:Port]
    Thread.new { @server.start }
    port
  end

  def new_browser
    chrome = [
      ENV['CHROMIUM_BIN'],
      '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome',
      '/Applications/Chromium.app/Contents/MacOS/Chromium',
      '/usr/bin/chromium-browser',
      '/snap/bin/chromium'
    ].compact.find { |p| File.executable?(p) }

    # process_timeout matches the cuprite driver in test_helper.rb: Chrome can
    # take well over 30s to first start on loaded CI runners.
    opts = { headless: true, process_timeout: 60, timeout: 30 }
    opts[:browser_path] = chrome if chrome # otherwise let Ferrum auto-detect (CI)
    Ferrum::Browser.new(**opts)
  end
end
