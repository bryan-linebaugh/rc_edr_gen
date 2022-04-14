# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Gem version
require 'edr_gen/version'

# Gem spec
Gem::Specification.new do |spec|
  spec.name          = 'edr_gen'
  spec.version       = EdrGen::VERSION
  spec.authors       = ['Bryan Linebaugh']
  spec.summary       = 'A command-line tool to generate system activity monitored by EDR agents.'
  spec.files         = Dir['lib/**/*', 'bin/*', 'log/*']
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency('thor', '~> 1.2.1')
end
