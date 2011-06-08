require 'mongo'
require 'mongo_logger'
class QueryJob < Struct.new(:map, :reduce, :options)
  
  PATIENTS_COLELCTION = "patients"
  RESULTS_COLLECTION = "query_results"
  @logger = nil
  def perform
   qe = QueryExecutor.new(map,reduce,@job_id)
   qe.execute
  end

  # need to get the id of the job we are running as
  def before(job,*args)
    
   @job_id = job.id
    msg_options = { :status=>:running}
    begin
      msg_options[:worker]=Delayed::Worker.name 
    rescue
    end
   logger.add(job,"job running",msg_options)
  end
 
 
  # need to get the id of the job we are running as
  def failure(job,*args)
    logger.add(job,"Job failed",{:worker=>Delayed::Worker.name, :error=>job.last_error, :status=>:failed, :failed_at=>job.failed_at})
  end
  
  # need to get the id of the job we are running as
  def enqueue(job,*args)
     logger.add(job,"Job enqueued", {:status=>:queued, :job=>job.attributes})
  end
  

  def error(job,*args)
      logger.add(job,"Job Error",{:worker=>Delayed::Worker.name, :error=>job.last_error, :status=>:error})
  end
  
  

  def after(job,*args)
    # see if it was rescheduled after an error
     if( Delayed::Job.exists?(:conditions =>{"_id"=>job.id}) && job.failed_at.nil?)
      logger.add(job,"Job Rescheduled",{:worker=>Delayed::Worker.name, :status=>:queued})
    end
  end

  def success(job,*args)
     logger.add(job,"Job successful",{:worker=>Delayed::Worker.name, :status=>:successful})
  end
  
  
  def logger
    @logger ||= MongoLogger.new
  end
  
  def self.submit(map, reduce, query_options = {})
    return Delayed::Job.enqueue(QueryJob.new(map,reduce,query_options), :run_at=>2.from_now)
  end


  def self.find_job(job_id)
      Delayed::Job.find(job_id)
  end
  
  
  def self.all_jobs()
      Delayed::Job.all
  end
  
  def self.job_status(job_id)
    jid = (job_id kind_of? BSON::ObjectId) ? job_id : BSON::ObjectId.from_string(job_id)
    job_exists = Delayed::Job.exists?(:conditions =>{"_id"=>jid})
     if(job_exists)
       job = Delayed::Job.find(job_id)
       return :running if (job.locked_at && job.failed_at.nil?)
       return :queued if( job.locked_at.nil? && job.locked_by.nil? && job.run_at >= Delayed::Job.db_time_now)
       return :failed if(job.failed_at )
     elsif Mongoid.master[RESULTS_COLLECTION].find_one({"_id"=>jid},{:fields => "_id"})
       return :completed
     end
     return :not_found
  end
  
  
  def self.job_results(job_id)
     return Mongoid.master[RESULTS_COLLECTION].find( {"_id" => BSON::ObjectId.from_string(job_id)})
  end
  
end
