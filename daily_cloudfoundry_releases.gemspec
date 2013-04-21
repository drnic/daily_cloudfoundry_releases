# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'daily_cloudfoundry_releases/version'

Gem::Specification.new do |spec|
  spec.name          = "daily_cloudfoundry_releases"
  spec.version       = DailyCloudfoundryReleases::VERSION
  spec.authors       = ["Dr Nic Williams"]
  spec.email         = ["drnicwilliams@gmail.com"]
  spec.description   = %q{Tasks to create final BOSH releases of cf-release for everyone to use}
  spec.summary       = %q{Tasks to create final BOSH releases of cf-release for everyone to use}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
