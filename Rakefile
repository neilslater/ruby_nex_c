# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'fileutils'
require 'open3'
require 'rbconfig'
require 'rspec/core/rake_task'
require 'rake/extensiontask'
require 'shellwords'
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

# Never package immediately after an instrumented native build.
task build: %i[clean compile]

YARD::Rake::YardocTask.new(:yard) do |task|
  task.options = ['--fail-on-warning']
end

rebuild_and_test_native = lambda do |mode, test: true|
  tasks = %w[clean compile]
  tasks << 'test' if test

  sh(
    { 'FOO_NATIVE_MODE' => mode },
    RbConfig.ruby,
    '-S',
    'bundle',
    'exec',
    'rake',
    *tasks
  )
end

gcc_compiler = lambda do |task_name|
  cc = RbConfig::CONFIG.fetch('CC')
  compiler_version = Open3.capture2e(*Shellwords.split(cc), '--version').first

  unless compiler_version.match?(/gcc/i) && !compiler_version.match?(/clang/i)
    abort "#{task_name} requires a GCC Ruby build (current compiler: #{cc})"
  end

  cc
end

# rubocop:disable Metrics/BlockLength
namespace :c do
  desc 'Compile the native extension with strict C warnings'
  task :lint do
    rebuild_and_test_native.call('lint', test: false)
  end

  desc 'Measure C coverage using the full Ruby test suite'
  task :coverage do
    gcc_compiler.call('c:coverage')
    abort 'c:coverage requires gcovr on PATH' unless system('gcovr', '--version', out: File::NULL)

    rebuild_and_test_native.call('coverage')

    FileUtils.mkdir_p('coverage/c')
    sh(
      'gcovr',
      '--root', '.',
      '--filter', 'ext/foo/',
      '--html-details', 'coverage/c/index.html',
      '--xml', 'coverage/c/cobertura.xml',
      '--txt', 'coverage/c/summary.txt',
      '--print-summary'
    )
  end

  desc 'Run the Ruby tests with ASan and UBSan'
  task :sanitize do
    abort 'c:sanitize requires Linux' unless RUBY_PLATFORM.match?(/linux/)

    cc = gcc_compiler.call('c:sanitize')
    libasan = Open3.capture2e(*Shellwords.split(cc), '-print-file-name=libasan.so').first.strip
    abort 'c:sanitize could not locate the GCC ASan runtime' if libasan.empty? || libasan == 'libasan.so'

    rebuild_and_test_native.call('sanitize', test: false)

    sh(
      {
        'ASAN_OPTIONS' => 'detect_leaks=0',
        'FOO_DISABLE_SIMPLECOV' => '1',
        'LD_PRELOAD' => libasan
      },
      RbConfig.ruby,
      '-S',
      'bundle',
      'exec',
      'rake',
      'test'
    )
  end
end
# rubocop:enable Metrics/BlockLength
