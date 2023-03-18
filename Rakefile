# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

Rake.add_rakelib 'lib/tasks'

RSpec::Core::RakeTask.new(:spec)
task default: :spec

desc 'Start a console with UCL loaded'
task :console do
  require 'pry'
  require 'ucl'
  puts 'Loaded UCL'
  ARGV.clear
  Pry.start
end
