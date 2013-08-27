# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'autoload_resources/version'

Gem::Specification.new do |spec|
  spec.name          = "autoload_resources"
  spec.version       = AutoloadResources::VERSION
  spec.authors       = ["barelyknown"]
  spec.email         = ["sean@buytruckload.com"]
  spec.description   = %q{Autoload resources for Rails controllers}
  spec.summary       = %q{Autoload resources for Rails controllers}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "guard-rspec"
  spec.add_dependency "activesupport"
  spec.add_dependency "controller_resource_class"
end
