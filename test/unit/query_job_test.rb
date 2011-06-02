require 'test_helper'

class QueryJobTest < ActiveSupport::TestCase
  def setup
   Delayed::Job.destroy_all
   Delayed::Worker.delay_jobs=false
  end
  
  def test_execute
    mf = File.read('test/fixtures/map_reduce/simple_map.js')
    rf = File.read('test/fixtures/map_reduce/simple_reduce.js')
    job = QueryJob.submit(mf,rf)
    
  end
  
end