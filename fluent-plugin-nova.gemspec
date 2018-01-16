# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
  gem.name          = "fluent-plugin-nova"
  gem.version       = "0.1"
  gem.authors       = "Benoît Bourbié"
  gem.email         = "bbourbie@splunk.com"
  gem.description   = %q{Output plugin for Nova.}
  gem.homepage      = "https://github.com/splunknova/fluentd"
  gem.summary       = %q{This plugin allows you to sent events to Splunk Nova or Splunk.}

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "fluentd", [">= 0.10.58", "< 2"]
  gem.add_dependency "yajl-ruby", '>= 1.3.0'
  gem.add_development_dependency "rake", '~> 0.9', '>= 0.9.2'
  gem.add_development_dependency "test-unit", '~> 3.1', '>= 3.1.0'
  gem.add_development_dependency "webmock", '>= 3.0'
end