class JobStats
   @@mongo_db = nil
  def self.db
    @@mongo_db ||= Mongoid.master
  end
    
  def self.stats
    
    begin
      Mongoid.master.stats
    rescue
      return {error: "Backend Down"}
    end
    
   failed = 0
   successful = 0
   retried = 0
   avg_runtime = []

   events =  self.db["job_log_events"].group({ key: "job_id" ,
    initial: {"retiries" => 0},
     reduce:  %{function(obj,prev){
        if(obj.status == "successful"){
          prev.finished =  obj.time;
        }
        else if(obj.status == "failed"){
          prev.failed = true;
        }
        else if(obj.status == "queued"){
          prev.queued =  obj.time;
        }
        else if(obj.status == "rescheduled"){
          prev.retries++; 
        }  
        else if(obj.status == 'running') {
          if( prev.last_runtime == null || prev.last_runtime < obj.time ){
            prev.last_runtime = obj.time;
          }
        }
    }}
    })
  
   
   events.each{ |e|
     failed += 1 if(!e['failed'].nil?)
     retired +=1 if( e['retried'])
      
     if e['finished'] 
        successful += 1
        avg_runtime << (e['finished'].to_f - e['queued'].to_f)
     end}
   
   
   
   total = Delayed::Job.count
   queued = Delayed::Job.count(conditions: {locked_by: nil})
   s = {queued: queued, running: total-queued, successful: successful, failed: failed, retried: retried, avg_runtime: avg_runtime.sum/avg_runtime.count, backend_status: :good}
   return s
  end
  
end

