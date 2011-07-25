require 'mongo'
require 'mongo_logger'
class QueryJob < Struct.new(:map, :reduce, :filter)
  
  PATIENTS_COLELCTION = "patients"
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
    msg_options = { :status=>:running}
    begin
      msg_options[:worker]=job.locked_by
    rescue
    end
   logger.add(job,"Job running",msg_options)
  end
 
 
  # need to get the id of the job we are running as
  def failure(job,*args)
    logger.add(job,"Job failed",{:worker=>job.locked_by, :error=>job.last_error, :status=>:failed, :failed_at=>job.failed_at})
  end
  
  # need to get the id of the job we are running as
  def enqueue(job,*args)
    logger.add(job,"Job enqueued", {:status=>:queued, :job=>job.attributes})
  end
  

  def error(job,*args)
      logger.add(job,"Job Error",{:worker=>job.locked_by, :error=>job.last_error, :status=>:error})
  end
  
  def after(job,*args)
    # see if it was rescheduled after an error
     if(!Mongoid.master[RESULTS_COLLECTION].find_one({"_id"=>job.id},{:fields => "_id"}))
      logger.add(job,"Job rescheduled",{ :status=>:queued})
    end
  end

  def success(job,*args)
     logger.add(job,"Job successful",{:worker=>job.locked_by, :status=>:successful})
  end
  
  
  def logger
    @@logger ||= MongoLogger.new
  end
  
  def self.logger
     @@logger ||= MongoLogger.new
  end
  
  def self.submit(map, reduce, filter = {})
    return Delayed::Job.enqueue(QueryJob.new(map,reduce,filter), :run_at=>2.from_now)
  end


  def self.find_job(job_id)
      Delayed::Job.find(job_id)
  end


  def self.cancel_job(job_id)
    job = find_job(job_id)
    if job && job.locked_by.nil?
      job.destroy
      logger.add(job,"Job Canceled",{status: :canceled})
    end
  end
  
  def self.job_logs(job_id)
    logger.job_log(BSON::ObjectId.from_string(job_id))
  end

  def self.all_jobs()
      Delayed::Job.all
  end
  
  def self.job_status(job_id)

    jid = BSON::ObjectId.from_string(job_id)
    job_exists = Delayed::Job.exists?(:conditions =>{"_id"=>jid})
     if(job_exists)
       job = Delayed::Job.find(job_id)
       return :failed if(!job.failed_at.nil? )
       return :queued if( job.locked_at.nil? && job.locked_by.nil? )
       return :running if (job.locked_at)
     elsif Mongoid.master[RESULTS_COLLECTION].find_one({"_id"=>jid},{:fields => "_id"})
       return :completed
     else
       jlog = job_logs(job_id)
       if jlog.size >0 && jlog.last['status'] == :canceled
         return :canceled
       end
     end
     return :not_found
  end
  
  
  def self.job_results(job_id)
     return Mongoid.master[RESULTS_COLLECTION].find_one( {"_id" => BSON::ObjectId.from_string(job_id)})
  end
  
end
