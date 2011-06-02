require 'mongo'

class QueryJob < Struct.new(:map, :reduce, :options)
 
  PATIENTS_COLELCTION = "patients"
  RESULTS_COLLECTION = "query_results"
 
  def perform
   db =  Mongoid.master
   results = db[PATIENTS_COLELCTION].map_reduce(map,reduce,options.merge({:raw=>true}))
   results["_id"] = @job_id
   db[RESULTS_COLLECTION].save(results)
  end

  # need to get the id of the job we are running as
  def before(job,*args)
     @job_id = job.id
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
    jid = BSON::ObjectId.from_string(job_id)
    job_exists = Delayed::Job.exists?(:conditions =>{"_id"=>jid})
     if(job_exists)
       job = Delayed::Job..find(job_id)
       return :running if (job.locked_at && job.failed_at.nil?)
       return :queued if( job.locked_at.nil? && job.locked_by.nil? && job.run_at >= Delayed::Job.db_time_now)
       return :failed if(job.failed_at )
     elsif Mongoid.master[RESULTS_COLLECTION].find_one({"_id"=>jid},{:fields => "_id"})
       return :completed
     end
     return :not_found
  end
  
  
  def self.job_results(job_id)
     return Mongoid.master[RESULTS_COLLECTION].find(job_id)
  end
  
end
