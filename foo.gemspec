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

  gem.required_ruby_version = '>= 3.3'

  gem.files = Dir[
    'CHANGELOG.md',
    'LICENSE.txt',
    'README.md',
    'ext/**/*.{c,h,rb}',
    'lib/**/*.rb'
  ]
  gem.extensions    = ['ext/foo/extconf.rb']
  gem.require_paths = ['lib']

  gem.metadata['source_code_uri'] = gem.homepage
  gem.metadata['bug_tracker_uri'] = "#{gem.homepage}/issues"
  gem.metadata['changelog_uri'] = "#{gem.homepage}/blob/main/CHANGELOG.md"
  gem.metadata['rubygems_mfa_required'] = 'true'
end
