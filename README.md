# Bootstrap Ruby Gem [![CI](https://github.com/twbs/bootstrap-rubygem/actions/workflows/ci.yml/badge.svg)](https://github.com/twbs/bootstrap-rubygem/actions/workflows/ci.yml) [![Gem](https://img.shields.io/gem/v/bootstrap.svg)](https://rubygems.org/gems/bootstrap)

[Bootstrap 5][bootstrap-home] ruby gem for Ruby on Rails (*Sprockets*/*Importmaps*) and Hanami (formerly Lotus).

For Sass versions of Bootstrap 3 and 2 see [bootstrap-sass](https://github.com/twbs/bootstrap-sass) instead.

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
gem 'bootstrap', '~> 5.3.3'
```

This gem requires a Sass engine, so make sure you have **one** of these gems in your Gemfile:
- [`dartsass-sprockets`](https://github.com/tablecheck/dartsass-sprockets): Dart Sass engine, recommended but only works for Ruby 2.6+ and Rails 5+
- [`dartsass-rails`](https://github.com/rails/dartsass-rails): Dart Sass engine, recommended for Rails projects that use Propshaft
- [`cssbundling-rails`](https://github.com/rails/cssbundling-rails): External Sass engine
- [`sassc-rails`](https://github.com/sass/sassc-rails): SassC engine, deprecated but compatible with Ruby 2.3+ and Rails 4

Also ensure that `sprockets-rails` is at least v2.3.2.

For wider browser compatibility, use [Autoprefixer][autoprefixer].
If you are using Rails, add the `autoprefixer-rails` gem to your app and ensure you have a JavaScript runtime (e.g. NodeJS).

`bundle install` and restart your server to make the files available through the pipeline.

Import Bootstrap styles in `app/assets/stylesheets/application.scss`:

```scss
// Custom bootstrap variables must be set or imported *before* bootstrap.
@import "bootstrap";
```

The available variables can be found [here](assets/stylesheets/bootstrap/_variables.scss).

Make sure the file has `.scss` extension (or `.sass` for Sass syntax). If you have just generated a new Rails app,
it may come with a `.css` file instead. If this file exists, it will be served instead of Sass, so rename it:

```console
$ mv app/assets/stylesheets/application.css app/assets/stylesheets/application.scss
```

Then, remove all the `*= require` and `*= require_tree` statements from the Sass file. Instead, use `@import` to import Sass files.

Do not use `*= require` in Sass or your other stylesheets will not be able to access the Bootstrap mixins and variables.

Bootstrap JavaScript can optionally use jQuery.
If you're using Rails 5.1+, you can add the `jquery-rails` gem to your Gemfile:

```ruby
gem 'jquery-rails'
```

Bootstrap tooltips and popovers depend on [popper.js] for positioning.
The `bootstrap` gem already depends on the
[popper_js](https://github.com/glebm/popper_js-rubygem) gem.

#### Importmaps

You can pin either `bootstrap.js` or `bootstrap.min.js` in `config/importmap.rb`
as well as `popper.js`:

```ruby
pin "bootstrap", to: "bootstrap.min.js", preload: true
pin "@popperjs/core", to: "popper.js", preload: true
```

Whichever files you pin will need to be added to `config.assets.precompile`:

```ruby
# config/initializers/assets.rb
Rails.application.config.assets.precompile += %w(bootstrap.min.js popper.js)
```

Add Bootstrap dependencies and Bootstrap to your `application.js`:

```js
import "@popperjs/core"
import "bootstrap"
```

#### Sprockets

Add Bootstrap dependencies and Bootstrap to your `application.js`:

```js
//= require jquery3
//= require popper
//= require bootstrap-sprockets
```

While `bootstrap-sprockets` provides individual Bootstrap components
for ease of debugging, you may alternatively require
the concatenated `bootstrap` for faster compilation:

```js
//= require jquery3
//= require popper
//= require bootstrap
```

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
In the application Sass file, replace `@import 'bootstrap'` with:

```scss
@import 'bootstrap-custom';
```

[bootstrap-home]: https://getbootstrap.com
[bootstrap-variables.scss]: https://github.com/twbs/bootstrap-rubygem/blob/master/templates/project/_bootstrap-variables.scss
[autoprefixer]: https://github.com/ai/autoprefixer
[popper.js]: https://popper.js.org
