require 'bundler'
Bundler::GemHelper.install_tasks

require 'rake/testtask'
require 'geminabox_client'
require 'rubygems/gem_runner'

gemspec = eval(File.read 'rack-webconsole-telcat.gemspec')

desc "Run rack-webconsole specs"
Rake::TestTask.new do |t|
  t.libs << "spec"
  t.test_files = FileList['spec/**/*_spec.rb']
  t.verbose = true
end

require 'yard'
YARD::Rake::YardocTask.new(:docs) do |t|
  t.files   = ['lib/**/*.rb']
  t.options = ['-m', 'markdown', '--no-private', '-r', 'Readme.md', '--title', 'rack-webconsole documentation']
end
task :doc => [:docs]

desc "Generate and open class diagram (needs Graphviz installed)"
task :graph do |t|
 `bundle exec yard graph -d --full --no-private | dot -Tpng -o graph.png && open graph.png`
end
task :default => [:test]

task :build do
  Gem::GemRunner.new.run ['build', "#{gemspec.name}.gemspec"]
end
	
task :release => [:build] do
  rake_config = YAML::load(File.read("#{ENV['HOME']}/.rake/rake.yml")) rescue {}
  GeminaboxClient.new(rake_config['geminabox']['url']).push "#{gemspec.name}-#{gemspec.version}.gem"
  puts "Gem #{gemspec.name} pushed to #{rake_config['geminabox']['url']}"
end
			