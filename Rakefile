require './lib/ebay-services-light-api'
require 'rake/testtask'
require 'bundler'
Bundler::GemHelper.install_tasks

Rake::TestTask.new(:test) do |t|
  t.libs << ['test','lib']
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

task :default => :test