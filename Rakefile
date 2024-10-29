# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rubocop/rake_task'

task default: %i[]

namespace :rbs do
  task gen: %i[] do
    sh 'rbs-inline --output --opt-out lib'
  end
end

desc 'run benchmark script'
task :benchmark do
  sh 'ruby ./scripts/benchmark.rb'
end

Rake::TestTask.new do |task|
  task.libs = %w[lib test]
  task.test_files = FileList['test/**/*.rb']
end

RuboCop::RakeTask.new
