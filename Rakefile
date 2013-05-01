require "bundler/gem_tasks"
require "rspec/core/rake_task"

task :default => [:test]

desc "Foo unit tests"
RSpec::Core::RakeTask.new(:test) do |t|
  t.pattern = "spec/*_spec.rb"
  t.verbose = true
end
