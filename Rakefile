require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "assette"
  gem.homepage = "http://github.com/Talby/assette"
  gem.license = "MIT"
  gem.summary = %Q{Treat all assets as equal}
  gem.description = %Q{Renders all asset types (coffeescript/sass/scss) as equals}
  gem.email = "me@tal.by"
  gem.authors = ["Tal Atlas"]
  # Include your dependencies below. Runtime dependencies are required when using your gem,
  # and development dependencies are only needed for development (ie running rake tasks, tests, etc)
  gem.add_runtime_dependency "rack", '~> 1'
  gem.add_runtime_dependency "thor", '~> 0'
  gem.add_runtime_dependency "json", '>= 1.4'
  gem.add_runtime_dependency "sass", '>= 3.1'
  gem.add_runtime_dependency "coffee-script", '~> 2'
  # gem.add_runtime_dependency "git"
  gem.add_runtime_dependency "mime-types", ">= 1.16"
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :default => :spec

require 'yard'
YARD::Rake::YardocTask.new
