# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'otis/generator/version'

Gem::Specification.new do |spec|
  spec.name          = "otis-generator"
  spec.version       = Otis::Generator::VERSION
  spec.authors       = ["tbueno"]
  spec.email         = ["tbueno@tbueno.com"]
  spec.description   = %q{An Otis Wrapper gem generator}
  spec.summary       = %q{This is an extension the Otis Framework that adds code generation features}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_dependency 'savon', '~> 2.2.0'
  spec.add_dependency 'thor'
end
