# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "heirloom/version"

Gem::Specification.new do |s|
  s.name        = "heirloom"
  s.version     = Heirloom::VERSION
  s.authors     = ["Brett Weaver"]
  s.email       = ["brett@weav.net"]
  s.homepage    = ""
  s.summary     = %q{I help with deploying code into the cloud}
  s.description = %q{I help build and manage building tar.gz files and deploying them into the cloud}

  s.rubyforge_project = "heirloom"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec", '~> 2.14.1'
  s.add_development_dependency "simplecov"

  s.add_runtime_dependency 'fog', '= 1.21.0'
  s.add_runtime_dependency 'hashie', '= 2.0.5'
  s.add_runtime_dependency 'trollop', '= 2.0'
  s.add_runtime_dependency 'xml-simple', '~> 1.1.3'
  s.add_runtime_dependency "unf", "= 0.1.3"
  s.add_runtime_dependency "unf_ext", "= 0.0.6"
end
