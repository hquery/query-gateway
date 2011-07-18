class MongoLogger
    LOG_COLLECTION = "job_log_events"    
    def initialize(options= {})
       @mongo_db = options[:mongo] || Mongoid.master
    end
    
   
    def add(job,message,extra={})
       @mongo_db[LOG_COLLECTION].insert(extra.merge({"job_id"=>job.id, "message"=>message, :time=>Time.new}))
    end
    
    
    def job_log(jid)
      entries =  @mongo_db[LOG_COLLECTION].find({:job_id=>jid},{:sort=>[[:time,:ascending]]}).to_a
    end
    
end
