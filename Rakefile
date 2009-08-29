require 'rake'

task :spec do
  gem 'rspec'
  require 'spec/rake/spectask'
  Spec::Rake::SpecTask.new(:lib_specs){|t| t.spec_files = FileList['spec/**/*.rb']}
  Rake::Task[:lib_specs].invoke
end
