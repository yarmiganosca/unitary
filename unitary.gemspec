# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'unitary/version'

Gem::Specification.new do |spec|
  spec.name          = 'unitary'
  spec.version       = Unitary::VERSION
  spec.authors       = ["Chris Hoffman"]
  spec.email         = ["yarmiganosca@gmail.com"]
  spec.description   = "Lets you easily use physical units in Ruby"
  spec.summary       = "Ruby Scientifc Units Library"
  spec.homepage      = "https://github.com/yarmiganosca/unitary"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = []
  spec.test_files    = spec.files.grep(%r{^spec/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
