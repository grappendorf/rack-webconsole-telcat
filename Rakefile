require 'rake'
require 'rake/clean'
require 'rubygems'
require 'rubygems/gem_runner'
require 'geminabox_client'
require 'rspec/core/rake_task'

gemspec = eval(File.read 'rack-webconsole-telcat.gemspec')

task :build do
	Gem::GemRunner.new.run ['build', "#{gemspec.name}.gemspec"]
end

RSpec::Core::RakeTask.new

desc 'Run RSpec code examples with coverage'
RSpec::Core::RakeTask.new('spec_coverage') do |t|
	ENV['RUN_WITH_COVERAGE'] = 'true'
end

task :release => [:build] do
	rake_config = YAML::load(File.read("#{ENV['HOME']}/.rake/rake.yml")) rescue {}
	GeminaboxClient.new(rake_config['geminabox']['url']).push "#{gemspec.name}-#{gemspec.version}.gem"
	puts "Gem #{gemspec.name} pushed to #{rake_config['geminabox']['url']}"
end
