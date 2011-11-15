require 'patient_console'
require 'bundler/setup'
require 'test/unit'
require 'tilt'
require 'coffee_script'
require 'sprockets'
require 'execjs'
require 'query_utilities'

namespace :patient do
  desc "Start interactive patient console"
  task :console do
    Rake.application['environment'].invoke
    PatientConsole.run
  end
  
end