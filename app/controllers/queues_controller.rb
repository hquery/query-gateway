require 'query_job'
require 'query_utilities'
class QueuesController < ApplicationController
  
  include QueryUtilities
 
  def index
    @jobs = QueryJob.all_jobs
  end

  def create
    map=params[:map].read
    reduce = params[:reduce].read
    filter = read_filter params[:filter].read if params[:filter]
    job = QueryJob.submit(map,reduce,filter)

    redirect_til_done(job.id)
  end


  def show
    logger.info(params)
    job_id = params[:id]
    case  QueryJob.job_status(job_id)
    when :failed
      logger.info "FAILED"
      render :text=>QueryJob.find_job(job_id).last_error, :status=>500
    when :completed
      logger.info "COMPLETED"
      render :json=>QueryJob.job_results(job_id)
    when :not_found
      logger.info "NOT FOUND"
      render :text=>"Job not Found", :status=>404
    else
      logger.info "REDIRECT"
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
     @job = @status != :completed ? QueryJob.find_job(@job_id) : nil
     
     render :json=>{:logs => QueryJob.job_logs(@job_id),
      :status =>@status}  
     
  end

   private 
   def redirect_til_done(job_id, js=nil)
      response.headers["retry_after"] = "10"
      response.headers["job_status"] = js if js
      redirect_to :action => 'show', :id => job_id, :status=>303
   end
   
   def read_filter(filter) 
     begin
       parse_json_to_hash(filter)
     rescue
       raise "bad filter format: " + filter
     end
   end
end
