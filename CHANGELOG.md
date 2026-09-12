# Changelog

The changelog is tracked here but also in [the Releases section of the GitHub project](https://github.com/twbs/bootstrap-rubygem/releases).
The changelog only includes changes specific to the RubyGem.

The Bootstrap framework changes can be found in [the Releases section of twbs/bootstrap](https://github.com/twbs/bootstrap/releases).
Release announcement posts on [the official Bootstrap blog](http://blog.getbootstrap.com) contain summaries of the most noteworthy changes made in each release of Bootstrap.

# 6.0.0.alpha1

First pre-release tracking Bootstrap 6 (upstream [`v6-dev`](https://github.com/twbs/bootstrap/tree/v6-dev)). **This is an alpha; expect breaking changes.**

* **Sass module system.** Bootstrap 6 replaced `@import` with `@use`/`@forward`.
  Import Bootstrap with `@use "bootstrap"` and customize variables via
  `@use "bootstrap" with (...)`. See the [v5→v6 migration guide](https://github.com/twbs/bootstrap/blob/v6-dev/skills/bootstrap-v5-v6-migration/SKILL.md).
* **Dart Sass is required to compile the stylesheets.** LibSass/SassC
  (`sassc-rails`) cannot compile the module system, so `sassc-rails` is no
  longer a supported Sass engine. Use `dartsass-sprockets` (a drop-in
  replacement), `dartsass-rails`, or `cssbundling-rails`. The minimum Ruby
  version is now 2.6 (compiling the stylesheets with a Ruby-side engine
  requires a recent Dart Sass, i.e. Ruby 3.1+).
* The standalone `bootstrap-grid`, `bootstrap-reboot`, and `bootstrap-utilities`
  Sass entry points were removed upstream; only `bootstrap` remains.
* **JavaScript is now ES-module only.** Bootstrap 6 removed the UMD bundle and
  the `window.bootstrap` global, so the `bootstrap-sprockets` Sprockets manifest
  and the `globalThis` shim are gone. Load Bootstrap via importmaps (see the
  README).
* **Popper replaced by [Floating UI](https://floating-ui.com/).** The `popper_js`
  runtime dependency was removed. The self-contained `bootstrap.bundle.{js,min.js}`
  builds inline both `@floating-ui/dom` and `vanilla-calendar-pro`, so a single
  importmap pin works with no extra dependencies (the recommended path). For
  lighter-weight pinning of the non-bundled `bootstrap.{js,min.js}` or individual
  component modules, a self-contained ESM build of `@floating-ui/dom` is also
  vendored as `floating-ui.js`.

# 5.3.4

* Autoprefixer is now optional.
  [#283](https://github.com/twbs/bootstrap-rubygem/pull/283)

# 5.3.3

* Adds support for other Sass engines: dartsass-sprockets, dartsass-rails, and cssbundling-rails.

# 4.2.1

* Bootstrap rubygem now depends on SassC instead of Sass.

# 4.0.0.beta2.1

Fixes an extraneous `sourceMappingURL` in `bootstrap.js`.
[#124](https://github.com/twbs/bootstrap-rubygem/issues/124)

# 4.0.0.beta2

Compass is no longer supported. Minimum required Sass version is now v3.5.2.
[#122](https://github.com/twbs/bootstrap-rubygem/pull/122)

# 4.0.0.alpha3.1

This release corresponds to the upstream Bootstrap 4 Alpha 3.
