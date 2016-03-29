require 'pathname'
require 'rspec/core/rake_task'

task :default => :run

desc 'Runs Sheetwise'
task :run do
  `ruby app/sheetwise.rb`
end

desc 'Runs Sheetwise test suite'
RSpec::Core::RakeTask.new(:spec => :treetop) do |task|
  task.pattern = 'app/spec/**{,/*/**}/*_spec.rb'
  task.rspec_opts = ['-r ./app/spec/rspec_config']
end

desc 'Generates Ruby parsers for the Treetop grammars'
task :treetop do
  cur_dir = Pathname.new(Rake.application.original_dir)
  grammar_files = Pathname.glob(cur_dir.join('app/lib/data/parsing/*.treetop'))

  `tt #{grammar_files.join(' ')}`
end
