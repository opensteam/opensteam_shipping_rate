require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the opensteam_shipping_rates plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the opensteam_shipping_rates plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'OpensteamShippingRates'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

namespace :opensteam do
  namespace :plugins do
    namespace :shipping_rate do

      desc "install the shipping_rate plugin for opensteam (copy migration files..)"
      task :install do
        system "rsync -ruv vendor/plugins/opensteam_shipping_rate/db/migrate db"
      end
    end
  end
end

