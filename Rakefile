require "bundler/gem_tasks"
require "rspec/core/rake_task"
require 'rake/extensiontask'

desc "Foo unit tests"
RSpec::Core::RakeTask.new(:test) do |t|
  t.pattern = "spec/*_spec.rb"
  t.verbose = true
end

gemspec = Gem::Specification.load('foo.gemspec')
Rake::ExtensionTask.new do |ext|
  ext.name = 'foo'
  ext.source_pattern = "*.{c,h}"
  ext.ext_dir = 'ext/foo'
  ext.lib_dir = 'lib/foo'
  ext.gem_spec = gemspec
end

task :default => [:compile, :test]
