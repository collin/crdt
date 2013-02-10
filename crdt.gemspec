$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "crdt/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "crdt"
  s.version     = CRDT::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of CRDT."
  s.description = "TODO: Description of CRDT."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_development_dependency "rspec"
  s.add_development_dependency "guard", "1.5.0"
  s.add_development_dependency "guard-rspec", " ~> 2.0.0"
  s.add_development_dependency 'rb-fsevent', '~> 0.9.1'
end
