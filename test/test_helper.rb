require 'cover_me'
ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  setup { load "#{Rails.root}/db/seeds.rb" }
end


def create_job
  
   mf = File.read('test/fixtures/map_reduce/simple_map.js')
   rf = File.read('test/fixtures/map_reduce/simple_reduce.js')
   job = QueryJob.submit(mf,rf)
   return job
end
