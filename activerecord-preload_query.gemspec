# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'activerecord/preload_query/version'

Gem::Specification.new do |spec|
  spec.name          = "activerecord-preload_query"
  spec.version       = Activerecord::PreloadQuery::VERSION
  spec.authors       = ["Jose Galisteo"]
  spec.email         = ["ceritium@gmail.com"]

  spec.summary       = %q{Preload queries like relations.}
  spec.description   = %q{PreloadQuery allows you preload queries and have them available as would a relations and `preload` of ActiveRecord.}
  spec.homepage      = "https://github.com/ceritium/activerecord-preload_query"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'minitest', '>= 3'
  spec.add_development_dependency 'sqlite3', '~> 1.3'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-byebug'
end
