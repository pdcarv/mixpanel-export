# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'mixpanel_export/version'

Gem::Specification.new do |spec|
  spec.name          = "mixpanel_export"
  spec.version       = MixpanelExport::VERSION
  spec.authors       = ["Pedro Carvalho"]
  spec.email         = ["incude@gmail.com"]
  spec.summary       = %q{Mixpanel's data export API client.}
  spec.description   = %q{Convenience wrapper for mixpanel's data export API.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler",  "~> 1.7"
  spec.add_development_dependency "rake",     "~> 10.0"
  spec.add_development_dependency "rspec",    "~> 3.2.0"
  spec.add_development_dependency "webmock",  "~> 1.20.4"
  spec.add_development_dependency "httparty", "~> 0.13.3"
end
