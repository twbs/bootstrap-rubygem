# Bootstrap Ruby Gem [![Build Status](https://travis-ci.org/twbs/bootstrap-rubygem.svg?branch=master)](https://travis-ci.org/twbs/bootstrap-rubygem) [![Gem](https://img.shields.io/gem/v/bootstrap.svg)](https://rubygems.org/gems/bootstrap)

---

**This is the Readme for the master version.
For the latest released alpha Readme, [click here](https://github.com/twbs/bootstrap-rubygem/tree/v4.0.0.alpha6).**

---

[Bootstrap 4][bootstrap-home] ruby gem for Ruby on Rails (Sprockets) and Compass.

For Sass versions of Bootstrap 3 and 2 see [bootstrap-sass](https://github.com/twbs/bootstrap-sass) instead.

## Installation

Please see the appropriate guide for your environment of choice:

* [Ruby on Rails 4+](#a-ruby-on-rails) or other Sprockets environment.
* [Compass](#b-compass-without-rails) not on Rails.


### a. Ruby on Rails

Add `bootstrap` to your Gemfile:

```ruby
gem 'bootstrap', git: 'https://github.com/twbs/bootstrap-rubygem'
```

Ensure that `sprockets-rails` is at least v2.3.2.

`bundle install` and restart your server to make the files available through the pipeline.

Import Bootstrap styles in `app/assets/stylesheets/application.scss`:

```scss
// Custom bootstrap variables must be set or imported *before* bootstrap.
@import "bootstrap";
```

The available variables can be found [here][bootstrap-variables.scss].

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

### b. Compass without Rails

Install the gem:

```console
$ gem install bootstrap -v 4.0.0.alpha6
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
[bootstrap-variables.scss]: https://github.com/twbs/bootstrap-rubygem/blob/master/templates/project/_bootstrap-variables.scss
[autoprefixer]: https://github.com/ai/autoprefixer
[popper.js]: https://popper.js.org
