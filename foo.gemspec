# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'foo/version'

Gem::Specification.new do |gem|
  gem.name          = 'foo'
  gem.version       = Foo::VERSION
  gem.authors       = ['Neil Slater']
  gem.email         = ['slobo.777@gmail.com']
  gem.description   = 'Native extension starter gem combining Ruby and C'
  gem.summary       = 'Native extension in C'
  gem.homepage      = 'https://github.com/neilslater/ruby_nex_c'
  gem.license       = 'MIT'

  gem.required_ruby_version = '>= 2.7.1'

  gem.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.extensions    = gem.files.grep(%r{/extconf\.rb$})
  gem.require_paths = ['lib']
  gem.metadata['rubygems_mfa_required'] = 'true'
end
