require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task default: :spec

task :compile do
  sh "cd #{File.dirname(__FILE__)}/rust && make"
end

task :run do
  require 'munkres_ru'
  result = MunkresRu.double_input(2)
  puts "Ruby result: #{result}"
end
