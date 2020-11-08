# Bootstrap Ruby Gem [![Build Status](https://travis-ci.org/twbs/bootstrap-rubygem.svg?branch=master)](https://travis-ci.org/twbs/bootstrap-rubygem) [![Gem](https://img.shields.io/gem/v/bootstrap.svg)](https://rubygems.org/gems/bootstrap)

[Bootstrap 4][bootstrap-home] ruby gem for Ruby on Rails (Sprockets) and Hanami (formerly Lotus).

For Sass versions of Bootstrap 3 and 2 see [bootstrap-sass](https://github.com/twbs/bootstrap-sass) instead.

## Installation

Please see the appropriate guide for your environment of choice:

* [Ruby on Rails 4+](#a-ruby-on-rails) or other Sprockets environment.
* [Other Ruby frameworks](#b-other-ruby-frameworks) not on Rails.


### a. Ruby on Rails

Add `bootstrap` to your Gemfile:

```ruby
gem 'bootstrap', '~> 4.5.3'
```

Ensure that `sprockets-rails` is at least v2.3.2.

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

Bootstrap JavaScript depends on jQuery.
If you're using Rails 5.1+, add the `jquery-rails` gem to your Gemfile:

```ruby
gem 'jquery-rails'
```

Bootstrap tooltips and popovers depend on [popper.js] for positioning.
The `bootstrap` gem already depends on the
[popper_js](https://github.com/glebm/popper_js-rubygem) gem.

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

### Sass: Autoprefixer

Bootstrap requires the use of [Autoprefixer][autoprefixer].
[Autoprefixer][autoprefixer] adds vendor prefixes to CSS rules using values from [Can I Use](http://caniuse.com/).

If you are using bootstrap with Rails, autoprefixer is set up for you automatically.
Otherwise, please consult the [Autoprefixer documentation][autoprefixer].

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
