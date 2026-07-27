# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rake/extensiontask'
require 'yard'

desc 'Foo unit tests'
RSpec::Core::RakeTask.new(:test) do |t|
  t.pattern = 'spec/*_spec.rb'
  t.verbose = true
end

gemspec = Gem::Specification.load('foo.gemspec')
Rake::ExtensionTask.new do |ext|
  ext.name = 'foo'
  ext.source_pattern = '*.{c,h}'
  ext.ext_dir = 'ext/foo'
  ext.lib_dir = 'lib/foo'
  ext.gem_spec = gemspec
end

task default: %i[compile test]

YARD::Rake::YardocTask.new(:yard) do |task|
  task.options = ['--fail-on-warning']
end

namespace :c do
  desc 'Compile the native extension with strict C warnings'
  task :lint do
    sh(
      {
        'CFLAGS' => [
          ENV.fetch('CFLAGS', nil),
          '-std=c11',
          '-Wall',
          '-Wextra',
          '-Wpedantic',
          '-Werror'
        ].compact.join(' ')
      },
      'bundle exec rake clobber compile'
    )
  end
end
