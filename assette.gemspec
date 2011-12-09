# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{assette}
  s.version = "0.0.13"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Tal Atlas}]
  s.date = %q{2011-12-09}
  s.description = %q{Renders all asset types (coffeescript/sass/scss) as equals}
  s.email = %q{me@tal.by}
  s.executables = [%q{assette}]
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    ".irbrc",
    ".rspec",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "assette.gemspec",
    "bin/assette",
    "examples/.asset_key",
    "examples/config/assets.rb",
    "examples/myapp/templates/bar/index.html.mustache",
    "examples/myapp/templates/foo/_partial.html.mustache",
    "examples/myapp/templates/foo/index.html.mustache",
    "examples/public/images/test.pdf",
    "examples/public/index.html",
    "examples/public/javascripts/foo.js",
    "examples/public/javascripts/handlebars.js",
    "examples/public/javascripts/one.js",
    "examples/public/javascripts/test.coffee",
    "examples/public/javascripts/three.js",
    "examples/public/javascripts/two.js",
    "examples/public/stylesheets/one.css",
    "examples/public/stylesheets/one1.sass",
    "examples/public/stylesheets/two.css",
    "examples/public/stylesheets/two2.scss",
    "lib/assette.rb",
    "lib/assette/cli.rb",
    "lib/assette/compiled_file.rb",
    "lib/assette/config.rb",
    "lib/assette/file.rb",
    "lib/assette/middleware.rb",
    "lib/assette/post_processor.rb",
    "lib/assette/post_processors.rb",
    "lib/assette/post_processors/cache_buster.rb",
    "lib/assette/post_processors/js_min.rb",
    "lib/assette/reader.rb",
    "lib/assette/readers.rb",
    "lib/assette/readers/coffee.rb",
    "lib/assette/readers/css.rb",
    "lib/assette/readers/js.rb",
    "lib/assette/readers/sass.rb",
    "lib/assette/readers/scss.rb",
    "lib/assette/run.ru",
    "lib/assette/server.rb",
    "lib/assette/template.rb",
    "lib/assette/template_set.rb",
    "lib/assette/view_helper.rb",
    "spec/assette_spec.rb",
    "spec/config_spec.rb",
    "spec/file_spec.rb",
    "spec/helper_spec.rb",
    "spec/post_processor_spec.rb",
    "spec/reader_spec.rb",
    "spec/server_spec.rb",
    "spec/spec_helper.rb",
    "spec/template_spec.rb",
    "test/helper.rb",
    "test/test_server.rb"
  ]
  s.homepage = %q{http://github.com/Talby/assette}
  s.licenses = [%q{MIT}]
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.8}
  s.summary = %q{Treat all assets as equal}
  s.test_files = [
    "examples/config/assets.rb",
    "spec/assette_spec.rb",
    "spec/config_spec.rb",
    "spec/file_spec.rb",
    "spec/helper_spec.rb",
    "spec/post_processor_spec.rb",
    "spec/reader_spec.rb",
    "spec/server_spec.rb",
    "spec/spec_helper.rb",
    "spec/template_spec.rb",
    "test/helper.rb",
    "test/test_server.rb"
  ]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rack>, ["~> 1"])
      s.add_runtime_dependency(%q<thor>, ["~> 0"])
      s.add_runtime_dependency(%q<json>, [">= 1.4"])
      s.add_runtime_dependency(%q<sass>, [">= 3.1"])
      s.add_runtime_dependency(%q<mime-types>, [">= 1.16"])
      s.add_runtime_dependency(%q<git>, [">= 0"])
      s.add_runtime_dependency(%q<coffee-script>, ["~> 2"])
      s.add_runtime_dependency(%q<uglifier>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.4.0"])
      s.add_development_dependency(%q<yard>, ["~> 0.6.0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.5.2"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
      s.add_development_dependency(%q<rack-test>, [">= 0"])
      s.add_runtime_dependency(%q<rack>, ["~> 1"])
      s.add_runtime_dependency(%q<thor>, ["~> 0"])
      s.add_runtime_dependency(%q<json>, [">= 1.4"])
      s.add_runtime_dependency(%q<sass>, [">= 3.1"])
      s.add_runtime_dependency(%q<coffee-script>, ["~> 2"])
      s.add_runtime_dependency(%q<uglifier>, [">= 0"])
      s.add_runtime_dependency(%q<mime-types>, [">= 1.16"])
    else
      s.add_dependency(%q<rack>, ["~> 1"])
      s.add_dependency(%q<thor>, ["~> 0"])
      s.add_dependency(%q<json>, [">= 1.4"])
      s.add_dependency(%q<sass>, [">= 3.1"])
      s.add_dependency(%q<mime-types>, [">= 1.16"])
      s.add_dependency(%q<git>, [">= 0"])
      s.add_dependency(%q<coffee-script>, ["~> 2"])
      s.add_dependency(%q<uglifier>, [">= 0"])
      s.add_dependency(%q<rspec>, ["~> 2.4.0"])
      s.add_dependency(%q<yard>, ["~> 0.6.0"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.5.2"])
      s.add_dependency(%q<rcov>, [">= 0"])
      s.add_dependency(%q<rack-test>, [">= 0"])
      s.add_dependency(%q<rack>, ["~> 1"])
      s.add_dependency(%q<thor>, ["~> 0"])
      s.add_dependency(%q<json>, [">= 1.4"])
      s.add_dependency(%q<sass>, [">= 3.1"])
      s.add_dependency(%q<coffee-script>, ["~> 2"])
      s.add_dependency(%q<uglifier>, [">= 0"])
      s.add_dependency(%q<mime-types>, [">= 1.16"])
    end
  else
    s.add_dependency(%q<rack>, ["~> 1"])
    s.add_dependency(%q<thor>, ["~> 0"])
    s.add_dependency(%q<json>, [">= 1.4"])
    s.add_dependency(%q<sass>, [">= 3.1"])
    s.add_dependency(%q<mime-types>, [">= 1.16"])
    s.add_dependency(%q<git>, [">= 0"])
    s.add_dependency(%q<coffee-script>, ["~> 2"])
    s.add_dependency(%q<uglifier>, [">= 0"])
    s.add_dependency(%q<rspec>, ["~> 2.4.0"])
    s.add_dependency(%q<yard>, ["~> 0.6.0"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.5.2"])
    s.add_dependency(%q<rcov>, [">= 0"])
    s.add_dependency(%q<rack-test>, [">= 0"])
    s.add_dependency(%q<rack>, ["~> 1"])
    s.add_dependency(%q<thor>, ["~> 0"])
    s.add_dependency(%q<json>, [">= 1.4"])
    s.add_dependency(%q<sass>, [">= 3.1"])
    s.add_dependency(%q<coffee-script>, ["~> 2"])
    s.add_dependency(%q<uglifier>, [">= 0"])
    s.add_dependency(%q<mime-types>, [">= 1.16"])
  end
end

