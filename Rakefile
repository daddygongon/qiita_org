#require "bundler/gem_tasks"
#require "rspec/core/rake_task"
#require "rake/testtask"

#RSpec::Core::RakeTask.new(:spec)

#task :default => :spec
require "bundler/gem_tasks"
require "rake/testtask"
#require 'yard'

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end
