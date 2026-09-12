# frozen_string_literal: true

# Bootstrap 6's stylesheets use the Sass module system (@use) and the CSS
# if()/sass() syntax, which only a recent Dart Sass can compile. The older
# Dart Sass releases that still resolve on Ruby < 3.1 fail to parse them, so
# the stylesheet tests skip on those engines. The probe compiles a snippet of
# the same syntax rather than Bootstrap itself, so a genuine Bootstrap
# regression on a capable engine still fails the tests.
module SassEngineSupport
  BOOTSTRAP6_SYNTAX_PROBE = <<~SCSS
    @use "sass:math";
    @function probe($a, $b) {
      @return if(sass($a > $b): math.div($a, $b); else: math.div($b, $a));
    }
    .probe { opacity: probe(2, 1); }
  SCSS

  def self.can_compile_bootstrap?
    return @can_compile_bootstrap if defined?(@can_compile_bootstrap)
    @can_compile_bootstrap =
      begin
        defined?(SassC::Engine) &&
          !SassC::Engine.new(BOOTSTRAP6_SYNTAX_PROBE, syntax: :scss).render.nil?
      rescue StandardError
        false
      end
  end

  def skip_unless_sass_can_compile_bootstrap!
    return if SassEngineSupport.can_compile_bootstrap?

    skip 'Sass engine cannot compile Bootstrap 6 stylesheets (recent Dart Sass required)'
  end
end
