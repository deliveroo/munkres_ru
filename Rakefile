require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task default: :spec

task :compile do
  sh "cd #{File.dirname(__FILE__)}/rust && make"
end
