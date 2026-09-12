# Bootstrap Ruby Gem [![CI](https://github.com/twbs/bootstrap-rubygem/actions/workflows/ci.yml/badge.svg)](https://github.com/twbs/bootstrap-rubygem/actions/workflows/ci.yml) [![Gem](https://img.shields.io/gem/v/bootstrap.svg)](https://rubygems.org/gems/bootstrap)

[Bootstrap 6][bootstrap-home] ruby gem for Ruby on Rails (*Sprockets*/*Importmaps*) and Hanami (formerly Lotus).

For Sass versions of Bootstrap 3 and 2 see [bootstrap-sass](https://github.com/twbs/bootstrap-sass) instead.

> **Bootstrap 6 (pre-release):** This is an alpha tracking the upstream
> [`v6-dev`](https://github.com/twbs/bootstrap/tree/v6-dev) branch.
> Bootstrap 6 moved its Sass to the [module system](https://sass-lang.com/documentation/at-rules/use)
> (`@use`/`@forward`), so its stylesheets require a **Dart Sass** engine to
> compile — LibSass/SassC (`sassc-rails`) cannot compile them and is no longer
> supported by this gem. Its JavaScript is ES-module only and is loaded via
> importmaps. See the [CHANGELOG](CHANGELOG.md).
> For the previous stable release, use `gem 'bootstrap', '~> 5.3.8'`.

**Ruby on Rails Note**: Newer releases of Rails have added additional ways for
assets to be processed. The `twbs/bootstrap-rubygem` is for use with Importmaps
or Sprockets, but not Webpack.

## Installation

Please see the appropriate guide for your environment of choice:

* [Ruby on Rails 4+](#a-ruby-on-rails) or other Sprockets environment.
* [Other Ruby frameworks](#b-other-ruby-frameworks) not on Rails.


### a. Ruby on Rails

Add `bootstrap` to your Gemfile:

```ruby
gem 'bootstrap', '~> 6.0.0.alpha1'
```

This gem requires a Sass engine, so make sure you have **one** of these gems in your Gemfile.
Bootstrap 6 stylesheets use the Sass module system, so a **Dart Sass** engine is
required to compile them — `sassc-rails` (LibSass) cannot compile Bootstrap 6 and
is no longer supported; migrate to one of:
- [`dartsass-sprockets`](https://github.com/tablecheck/dartsass-sprockets): Dart Sass engine, recommended (a drop-in replacement for `sassc-rails`). Compiling Bootstrap 6 requires version 3.1+ and therefore Ruby 3.1+; older versions install on Ruby 2.6+ but bundle a Dart Sass too old for Bootstrap 6.
- [`dartsass-rails`](https://github.com/rails/dartsass-rails): Dart Sass engine, recommended for Rails projects that use Propshaft
- [`cssbundling-rails`](https://github.com/rails/cssbundling-rails): External Sass engine, runs Dart Sass in Node so it works on any supported Ruby

Also ensure that `sprockets-rails` is at least v2.3.2.

For wider browser compatibility, use [Autoprefixer][autoprefixer].
If you are using Rails, add the `autoprefixer-rails` gem to your app and ensure you have a JavaScript runtime (e.g. NodeJS).

`bundle install` and restart your server to make the files available through the pipeline.

Import Bootstrap styles in `app/assets/stylesheets/application.scss` with `@use`
(Bootstrap 6 no longer supports `@import`):

```scss
@use "bootstrap";
```

To customize Bootstrap's variables, configure them through the `@use ... with`
rule instead of setting globals before an `@import`:

```scss
@use "bootstrap" with (
  $primary: #c0ffee,
  $enable-rounded: false
);
```

The available variables can be found in [`bootstrap/_config.scss`](assets/stylesheets/bootstrap/_config.scss).

Make sure the file has `.scss` extension (or `.sass` for Sass syntax). If you have just generated a new Rails app,
it may come with a `.css` file instead. If this file exists, it will be served instead of Sass, so rename it:

```console
$ mv app/assets/stylesheets/application.css app/assets/stylesheets/application.scss
```

Then, remove all the `*= require` and `*= require_tree` statements from the Sass file. Instead, use `@use` to import Sass files.

Do not use `*= require` in Sass or your other stylesheets will not be able to access the Bootstrap mixins and variables.

### JavaScript

Bootstrap 6's JavaScript is **ES-module only** — there is no UMD bundle and no
`window.bootstrap` global, so the old Sprockets `//= require bootstrap-sprockets`
concatenation is gone. Load it through **importmaps** instead.

Bootstrap 6 uses [Floating UI](https://floating-ui.com/) (`@floating-ui/dom`)
for positioning tooltips, popovers, and menus, replacing Popper. A self-contained
ESM build of `@floating-ui/dom` is **vendored in this gem** as `floating-ui.js`,
so you do not need an external dependency for it.

#### Importmaps

The simplest option is the self-contained **bundle**
(`bootstrap.bundle.min.js`), which inlines Floating UI and `vanilla-calendar-pro`,
so it needs no other pins. In `config/importmap.rb`:

```ruby
pin "bootstrap", to: "bootstrap.bundle.min.js", preload: true
```

Then import the components you need from your application's entrypoint:

```js
// app/javascript/application.js
import { Tooltip } from "bootstrap"

for (const el of document.querySelectorAll('[data-bs-toggle="tooltip"]')) {
  new Tooltip(el)
}
```

The data-attribute APIs (`data-bs-toggle`, etc.) work automatically once the
module is loaded.

<details>
<summary>Lighter-weight pinning (without the bundle)</summary>

If you want to avoid the bundled Floating UI / Datepicker code, pin the
non-bundled `bootstrap.min.js` together with the gem's **vendored**
`@floating-ui/dom` build:

```ruby
pin "bootstrap", to: "bootstrap.min.js", preload: true
pin "@floating-ui/dom", to: "floating-ui.js", preload: true
```

Individual components are also available as separate modules
(e.g. `pin "bootstrap/tooltip", to: "bootstrap/tooltip.js"`) for finer-grained
pinning. The [Datepicker](https://getbootstrap.com/) component additionally
depends on [`vanilla-calendar-pro`](https://www.npmjs.com/package/vanilla-calendar-pro),
which is **not** vendored — if you use it (or the non-bundled `bootstrap.min.js`,
which imports it), pin it from a CDN:

```ruby
pin "vanilla-calendar-pro", to: "https://ga.jspm.io/npm:vanilla-calendar-pro@3.1.0/index.js"
```
</details>

### b. Other Ruby frameworks

If your framework uses Sprockets or Hanami,
the assets will be registered with Sprockets when the gem is required,
and you can use them as per the Rails section of the guide.

Otherwise you may need to register the assets manually.
Refer to your framework's documentation on the subject.

## Configuration

### Sass: Individual components

By default all of Bootstrap is imported.

You can also import components explicitly. To start with a full list of modules copy
[`_bootstrap.scss`](assets/stylesheets/_bootstrap.scss) file into your assets as `_bootstrap-custom.scss`.
Then comment out components you do not want from `_bootstrap-custom`.
In the application Sass file, replace `@use 'bootstrap'` with:

```scss
@use 'bootstrap-custom';
```

[bootstrap-home]: https://getbootstrap.com
[autoprefixer]: https://github.com/ai/autoprefixer
