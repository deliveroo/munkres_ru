# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'munkres_ru/version'

Gem::Specification.new do |spec|
  spec.name          = 'munkres_ru'
  spec.version       = MunkresRu::VERSION
  spec.authors       = ['Ivan Pirlik']
  spec.email         = ['ivan.pirlik@deliveroo.co.uk']

  spec.summary       = 'Kuhn-Munkres implemented in Rust'
  spec.homepage      = 'https://github.com/deliveroo/munkres_ru'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.extensions = Dir['rust/extconf.rb']

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
