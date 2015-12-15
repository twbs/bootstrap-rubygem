# Bootstrap Ruby Gem [![Build Status](https://travis-ci.org/twbs/bootstrap-rubygem.svg?branch=master)](https://travis-ci.org/twbs/bootstrap-rubygem) [![Gem](https://img.shields.io/gem/v/bootstrap.svg)](https://rubygems.org/gems/bootstrap)

[Bootstrap 4][bootstrap-home] ruby gem for Ruby on Rails (Sprockets) and Compass.

For Sass versions of Bootstrap 3 and 2 see [bootstrap-sass](https://github.com/twbs/bootstrap-sass) instead.

## Installation

Please see the appropriate guide for your environment of choice:

* [Ruby on Rails 4+](#a-ruby-on-rails) or other Sprockets environment.
* [Compass](#b-compass-without-rails) not on Rails.


### a. Ruby on Rails

Add `bootstrap` to your Gemfile:

```ruby
gem 'bootstrap', '~> 4.0.0.alpha3'
```

Ensure that `sprockets-rails` is at least v2.3.2.

`bundle install` and restart your server to make the files available through the pipeline.

Import Bootstrap styles in `app/assets/stylesheets/application.scss`:

```scss
// Custom bootstrap variables must be set or import before bootstrap itself.
@import "bootstrap";
```

Make sure the file has `.scss` extension (or `.sass` for Sass syntax). If you have just generated a new Rails app,
it may come with a `.css` file instead. If this file exists, it will be served instead of Sass, so rename it:

```console
$ mv app/assets/stylesheets/application.css app/assets/stylesheets/application.scss
```

Then, remove all the `*= require` and `*= require_tree` statements from the Sass file. Instead, use `@import` to import Sass files.

Do not use `*= require` in Sass or your other stylesheets will not be able to access the Bootstrap mixins and variables.

Require Bootstrap Javascripts in `app/assets/javascripts/application.js`:

```js
//= require jquery
//= require bootstrap-sprockets
```

While `bootstrap-sprockets` provides individual Bootstrap components for ease of debugging, you may alternatively require the concatenated `bootstrap` for faster compilation:

```js
//= require jquery
//= require bootstrap
```

Tooltips and popovers depend on [tether][tether] for positioning.
If you use them, add tether to the Gemfile:

```ruby
source 'https://rails-assets.org' do
  gem 'rails-assets-tether', '>= 1.1.0'
end
```

Then, run `bundle`, restart the server, and require tether before bootstrap but after jQuery:

```js
//= require jquery
//= require tether
//= require bootstrap-sprockets
```

### b. Compass without Rails

Install the gem:

```console
$ gem install bootstrap -v 4.0.0.alpha1
```

**If you have an existing Compass project:**

1. Require `bootstrap` in `config.rb`:

    ```ruby
    require 'bootstrap'
    ```

2. Install Bootstrap with:

    ```console
    $ bundle exec compass install bootstrap
    ```

**If you are creating a new Compass project, you can generate it with bootstrap support:**

```console
$ bundle exec compass create my-new-project -r bootstrap --using bootstrap
```

or, alternatively, if you're not using a Gemfile for your dependencies:

```console
$ compass create my-new-project -r bootstrap --using bootstrap
```

This will create a new Compass project with the following files in it:

* [styles.scss](/templates/project/styles.scss) - main project Sass file, imports Bootstrap and variables.
* [_bootstrap-variables.scss](/templates/project/_bootstrap-variables.scss) - all of Bootstrap variables, override them here.

Some bootstrap mixins may conflict with the Compass ones.
If this happens, change the import order so that Compass mixins are loaded later.

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

[bootstrap-home]: http://v4-alpha.getbootstrap.com/
[autoprefixer]: https://github.com/ai/autoprefixer
[tether]: http://github.hubspot.com/tether/
