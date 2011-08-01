class JobLog
  include Mongoid::Document

  field :status, type: Symbol
  field :last_update, type: Time
  field :messages, type: Array, default:[]
  field :job_id, type: String
  field :job, type: Hash


  def self.add(job,message,status,extra={})
    time = Time.now
    jlog = JobLog.find_or_create_by( job_id: job.id.to_s)
    jlog.job = job.attributes 
    jlog.status = status
    jlog.last_update = time
    jlog.messages << extra.merge({"status"=>status, "job_id"=>job.id.to_s, "message"=>message, "time"=>time})
    jlog.save
  end


  def self.all_grouped_by_status
    self.collection.group({reduce:"function(k,v){k.entires.push(v)}", initial:{entries:[]}, key:"status"})
  end

end
