class MongoLogger
    LOG_COLLECTION = "job_log_events"    
    def initialize(options= {})
       @mongo_db = options[:mongo] || Mongoid.master
    end
    
   
    def add(job,message,extra={})
       time = Time.now
       jlog = get_job_log(job.id)
       jlog['current_status']=extra[:status]
       jlog['last_update'] = time

       jlog['messages'] << extra.merge({"job_id"=>job.id, "message"=>message, "time"=>time})
       @mongo_db[LOG_COLLECTION].save(jlog, {safe: true})
    end
    
    
    def job_log(jid)
       @mongo_db[LOG_COLLECTION].find_one({:job_id=>jid})
    end
    
    
    private 
    
    def get_job_log(jid)
      jlog =  @mongo_db[LOG_COLLECTION].find_one({job_id: jid}) || {"job_id" => jid, "messages" => []}     
    end
end
