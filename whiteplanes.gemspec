# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'whiteplanes/version'

Gem::Specification.new do |spec|
  spec.name = 'whiteplanes'
  spec.version = Whiteplanes::VERSION
  spec.authors = ['Takuya Katsurada']
  spec.email = ['mail@nutcrack.io']
  spec.summary = 'Whitespace interpreter writen in Ruby'
  spec.description = 'Whitespace interpreter writen in Ruby'
  spec.homepage = 'https://github.com/whiteplanes/whiteplanes.rb'
  spec.license = 'MIT'
  spec.files = Dir.glob("lib/**/*.rb")
  spec.require_paths = ["lib"]
  spec.required_ruby_version = '>= 2.0.0'

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end