require 'mongo'

class QueryJob < Struct.new(:map, :reduce,:functions, :filter, :query_id)

  FINISHED_COLLECTION = "finished_jobs"
  RESULTS_COLLECTION = "query_results"

  # run the job using the query executor
  def perform
   qe = QueryExecutor.new(map, reduce,functions, query_id, filter)
   results = qe.execute
   result = Result.new results
   result.query = Query.find(query_id)
   result.save!
  end

  def before(job,*args)
    query = Query.find(query_id)
    query.status_change(:running, "Job running")
  end

  def failure(job,*args)
    query = Query.find(query_id)
    query.status_change(:failed, "Job failed - Error: #{job.last_error}")
  end

  def enqueue(job,*args)
    query = Query.find(query_id)
    query.status_change(:queued, "Job enqueued")
  end

  def error(job,*args)
    query = Query.find(query_id)
    query.status_change(:error, "Job error - Error: #{job.last_error}")
  end

  def after(job,*args)
    # see if it was rescheduled after an error
    if(! Query.find(query_id).result)
      query = Query.find(query_id)
      query.status_change(:rescheduled, "Job rescheduled")
    end
  end

  def success(job,*args)
    query = Query.find(query_id)
    query.status_change(:complete, "Job successful")
  end

  def self.submit(map, reduce, functions , filter = {}, query_id)
    return Delayed::Job.enqueue(QueryJob.new(map, reduce, functions,filter, query_id), :run_at=>2.from_now)
  end

  def self.find_job(job_id)
    Delayed::Job.find(BSON::ObjectId.from_string(job_id))
  end

  def self.cancel_job(job_id)
    job = find_job(job_id)
    if job && job.locked_by.nil?
      job.destroy
      query = Query.find(job.payload_object.query_id)
      query.status_change(:canceled, "Job canceled")
    end
  end
  
  def self.all_jobs()
    Delayed::Job.all
  end
  
  def self.job_results(job_id)
    return Mongoid.master[RESULTS_COLLECTION].find_one( {"_id" => BSON::ObjectId.from_string(job_id)})
  end
end
