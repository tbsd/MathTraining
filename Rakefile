require 'rubygems'
require 'bundler'
require 'rake/testtask'

task :default => :spec

Rake::TestTask.new(:spec) do |t|
  t.test_files = FileList['spec/*_spec.rb']
end

Rake::TestTask.new(:system) do |t|
  t.test_files = FileList['spec/*_system.rb']
end
