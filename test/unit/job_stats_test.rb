require 'test_helper'

class JobStatsTest < ActiveSupport::TestCase

  SUCCESSFUL_COUNT = 3
  FAILED_COUNT = 2
  RUNNING_COUNT = 4
  RESCHEDULED_COUNT = 2
  QUEUED_COUNT = 6

  setup do

    dump_jobs
    dump_database

    SUCCESSFUL_COUNT.times do
      job = Factory(:successful_job)
      #job.destroy
    end
    
    FAILED_COUNT.times do
      job = Factory(:failed_job)
      #job.destroy
    end

    RUNNING_COUNT.times do
      Factory(:running_job)
    end

    RESCHEDULED_COUNT.times do
      Factory(:rescheduled_job)
    end
    
    QUEUED_COUNT.times do
      Factory(:queued_job)
    end
  end
  
  test "when the database is down, job stats should report properly" do
    Mongoid.master.expects(:stats).raises(Mongo::ConnectionFailure, 'mock database exception')
    stats = JobStats.stats
    assert_equal ({error: "Backend Down"}), stats
  end

  test "job stats should report properly" do
    stats = JobStats.stats
    assert_equal SUCCESSFUL_COUNT, stats["complete"]
    assert_equal FAILED_COUNT, stats["failed"]
    assert_equal RUNNING_COUNT , stats["running"]
    assert_equal RESCHEDULED_COUNT, stats["rescheduled"]
    assert_equal QUEUED_COUNT, stats["queued"]
    assert_equal 30, (stats["avg_runtime"]/1000).to_i
  end

  
end