$LOAD_PATH.push File.expand_path("./spec")

require 'rspec'
require 'rspec/core/rake_task'

desc 'Default: run specs.'
task :default => :spec

desc "run specs"
RSpec::Core::RakeTask.new do |t|
  t.pattern = "spec/**/*_spec.rb"
end

desc "run js tests"
task "browser" do
  sh "phantomjs vendor/qunit-phantomjs-runner.js test/suite.html"
end

desc "push to github (run tests first)"
task "push" do
  sh "rake && rake browser && git push origin master"
end
