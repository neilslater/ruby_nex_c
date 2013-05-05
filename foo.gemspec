# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'foo/version'

Gem::Specification.new do |gem|
  gem.name          = "foo"
  gem.version       = Foo::VERSION
  gem.authors       = ["Neil Slater"]
  gem.email         = ["slobo.777@gmail.com"]
  gem.description   = %q{Native extension starter gem combining Ruby and C}
  gem.summary       = %q{Native extension in C}
  gem.homepage      = "http://slobo777.deviantart.com/"

  gem.add_development_dependency "rspec", ">= 2.13.0"
  gem.add_development_dependency "rake", ">= 1.9.1"
  gem.add_development_dependency "rake-compiler"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.extensions    = gem.files.grep(%r{/extconf\.rb$})
  gem.require_paths = ["lib"]
end
