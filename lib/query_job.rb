require 'mongo'
require 'job_log'
class QueryJob < Struct.new(:map, :reduce, :filter)
  
  FINISHED_COLLECTION = "finished_jobs"
  RESULTS_COLLECTION = "query_results"
  
  @@logger = nil
  # run the job using the query executor
  def perform
   qe = QueryExecutor.new(map,reduce,@job_id,filter)
   qe.execute
  end

  # need to get the id of the job we are running as
  def before(job,*args)
    
   @job_id = job.id
    msg_options = { }
    begin
      msg_options[:worker]=job.locked_by
    rescue
    end
    JobLog.add(job,"job running",:running, msg_options)
  end
 
 
  # need to get the id of the job we are running as
  def failure(job,*args)
    JobLog.add(job,"Job failed",:failed, {:worker=>job.locked_by, :error=>job.last_error,  :failed_at=>job.failed_at})
    
  end
  
  # need to get the id of the job we are running as
  def enqueue(job,*args)
    JobLog.add(job,"Job enqueued", :queued, {})
  end
  

  def error(job,*args)
    JobLog.add(job,"Job Error",:error, {:worker=>job.locked_by, :error=>job.last_error})
  end
  
  def after(job,*args)
    # see if it was rescheduled after an error
     if(!Mongoid.master[RESULTS_COLLECTION].find_one({"_id"=>job.id},{:fields => "_id"}))
      JobLog.add(job,"Job Rescheduled",:rescheduled,{})
    end
  end

  def success(job,*args)
     JobLog.add(job,"Job successful",:success, {:worker=>job.locked_by})
  end
  
  
  
  def self.submit(map, reduce, filter = {})
    return Delayed::Job.enqueue(QueryJob.new(map,reduce,filter), :run_at=>2.from_now)
  end


  def self.find_job(job_id)
      Delayed::Job.find(BSON::ObjectId.from_string(job_id))
  end


  def self.cancel_job(job_id)
    job = find_job(job_id)
    if job && job.locked_by.nil?
      job.destroy
      JobLog.add(job,"Job Canceled",:canceled, {})
    end
  end
  
  def self.job_logs(job_id)
    JobLog.job_log(BSON::ObjectId.from_string(job_id))
  end

  def self.all_jobs()
      Delayed::Job.all
  end
  
  def self.job_status(job_id)
    jlog = nil
    begin
     jlog = JobLog.first({conditions:{job_id: job_id}})
    rescue 
    end
    
    return (jlog) ? jlog.status : :not_found
  end
  
  
  def self.job_results(job_id)
     return Mongoid.master[RESULTS_COLLECTION].find_one( {"_id" => BSON::ObjectId.from_string(job_id)})
  end
  
end
