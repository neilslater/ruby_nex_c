# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'foo/version'

Gem::Specification.new do |gem|
  gem.name          = "foo"
  gem.version       = Foo::VERSION
  gem.authors       = ["Neil Slater"]
  gem.email         = ["slobo777@gmail.com"]
  gem.description   = %q{Test of adding native extension to bundle gem}
  gem.summary       = %q{Native extension}
  gem.homepage      = "http://www.example.com/"

  gem.add_development_dependency "rake-compiler"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.extensions    = gem.files.grep(%r{/extconf\.rb$})
  gem.require_paths = ["lib"]
end
