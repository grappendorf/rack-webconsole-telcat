# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rack/webconsole/version"

Gem::Specification.new do |s|
  s.name        = "rack-webconsole-telcat"
  s.version     = Rack::Webconsole::VERSION
  s.authors     = ["Josep M. Bach", "Josep Jaume Rey", "Oriol Gual"]
  s.summary     = %q{Rack-based console inside your web applications}
  s.description = %q{Rack-based console inside your web applications}

  s.add_runtime_dependency 'rack'
  s.add_runtime_dependency 'multi_json'
  s.add_runtime_dependency 'ripl', '~> 0.5.1'
  s.add_runtime_dependency 'ripl-multi_line', '~> 0.3.0'

  s.add_development_dependency 'minitest'
  s.add_development_dependency 'purdytest'
  s.add_development_dependency 'geminabox'
  
  # Since we can't have a git dependency in gemspec, we specify this
  # dependency directly in the Gemfile. Once a new mocha version is released,
  # we should uncomment this line and remove mocha from the Gemfile.
  # s.add_development_dependency 'mocha'

  s.add_development_dependency 'yard'
  s.add_development_dependency 'bluecloth'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]
end
