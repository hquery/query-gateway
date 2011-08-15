require 'cover_me'
ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'factory_girl'
require 'mocha'

Factory.find_definitions

class ActiveSupport::TestCase
  setup { load "#{Rails.root}/db/seeds.rb" }
end

def dump_database
  db = Mongoid.master
  QueryUtilities.clean_js_libs
  QueryUtilities.load_js_libs
  db.collection('job_logs').remove({}) if db['job_log_events']
  db.collection('query_results').remove({}) if db['query_results']
end

def dump_jobs
  Delayed::Job.destroy_all
end

def create_job
   mf = File.read('test/fixtures/map_reduce/simple_map.js')
   rf = File.read('test/fixtures/map_reduce/simple_reduce.js')
   job = QueryJob.submit(mf,rf)
   return job
end
