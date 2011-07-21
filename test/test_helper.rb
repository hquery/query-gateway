require 'cover_me'
ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'factory_girl'

Factory.find_definitions

class ActiveSupport::TestCase
  setup { load "#{Rails.root}/db/seeds.rb" }
end

def dump_database
  db = Mongoid::Config.master
  db['system.js'].remove({}) if db['system.js']
  db['job_log_events'].remove({}) if db['job_log_events']
  db['query_results'].remove({}) if db['query_results']
end

def dump_jobs
  Delayed::Job.destroy_all
end

