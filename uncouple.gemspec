# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'uncouple/version'

Gem::Specification.new do |spec|

  spec.name          = "uncouple"
  spec.version       = Uncouple::VERSION
  spec.authors       = ["Spencer Steffen"]
  spec.email         = ["spencer@nightout.com"]

  spec.summary       = %q{Uncouple your business logic from rails.}
  spec.description   = %q{Uncouple your business logic from rails.}
  spec.homepage      = "https://github.com/citrus/uncouple"
  spec.license       = "MIT"
  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "strong_parameters", "~> 0.2.0"

end
