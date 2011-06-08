require 'query_job'
class QueuesController < ApplicationController
  
 
  def index
    @jobs = QueryJob.all_jobs
  end

  def create
    map =params[:map].read
    reduce = params[:reduce].read
    job = QueryJob.submit(map,reduce)
    logger.info("JOB ID #{job.id}")
    redirect_til_done(job.id)
  end


  def show
    logger.info(params)
    job_id = params[:id]
    logger.info("JOB ID #{job_id}")
    case  QueryJob.job_status(job_id)
    when :failed
      render :text=>QueryJob.getJob(job_id).last_error, :status=>500
    when :completed
      render :json=>QueryJob.job_results(job_id)
    when :not_found
      render :text=>"Job not Found", :status=>404
    else
      redirect_til_done(job_id)
    end

  end
  
  
  
  def job_status
     @job_id = params[:id]
     @status = QueryJob.job_status(@job_id)
     if @status == :not_found
       render :text=>"Job not Found", :status=>404
       return
     end
     @job = @status != :completed ? QueryJob.get_job(@job_id) : nil
     
     render :json=>{:logs => QueryJob.job_logs(@job_id),
      :status =>@status}  
     
  end

   private 
   def redirect_til_done(job_id, js=nil)
      response.headers["retry_after"] = "10"
      response.headers["job_status"] = js if js
      redirect_to :action => 'show', :id => job_id, :status=>303
   end
end
