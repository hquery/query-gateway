#require 'mongo'

class QueryJob < Struct.new(:format, :map, :reduce,:functions, :filter, :query_id)

  # run the job using the query executor
  def perform
   qe = QueryExecutor.new(format, map, reduce, functions, query_id.to_s, filter)
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
    query.status_change(:failed, "Job failed")
    query.error_message = job.last_error
    query.save
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
    # no op
  end

  def success(job,*args)
    query = Query.find(query_id)
    query.status_change(:complete, "Job successful")
  end

  def self.submit(format, map, reduce, functions, filter = {}, query_id)
    return Delayed::Job.enqueue(QueryJob.new(format, map, reduce, functions, filter, query_id), :run_at=>2.from_now)
  end

  def self.find_job(job_id)
    #Delayed::Job.find(Moped::BSON::ObjectId.from_string(job_id))
    Delayed::Job.find(Moped::BSON::ObjectId(job_id))
  end

  def self.cancel_job(job_id)
    job = find_job(job_id)
    if job && job.locked_by.nil?
      job.destroy
      query = Query.find(job.payload_object.query_id)
      query.status_change(:canceled, "Job canceled")
    end
  end
  
end
