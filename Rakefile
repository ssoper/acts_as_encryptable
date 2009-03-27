require 'rake'
require 'rake/testtask'

namespace :gem do
 
  task :default => :build

  desc 'Build the acts_as_encryptable gem'
  task :build do
    Dir['*.gem'].each do |gem_filename|
      sh "rm -rf #{gem_filename}"
    end
    sh "gem build acts_as_encryptable.gemspec"
  end

  desc 'Install the acts_as_encryptable gem'
  task :install do
    gem_filename = Dir['*.gem'].first
    sh "sudo gem install --local #{gem_filename}"
  end

end
 
task :default => ['gem:build', 'gem:install']

namespace :test do
  Rake::TestTask.new(:unit) do |t|
    t.libs << 'test'
    t.pattern = 'test/unit/*_test.rb'
    t.verbose = true  
  end
end

task :test do
  Rake::Task['test:unit'].invoke
end