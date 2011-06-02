require 'query_job'
class QueuesController < ApplicationController
  
 
  def index
    @jobs = QueryJob.all_jobs
  end

  def create
    map =params[:map].read
    reduce = params[:reduce].read
    job = QueryJob.submit(map,reduce)
    redirect_til_done(job.id)
  end


  def show
    job_id = params[:id]
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

   private 
   def redirect_til_done(job_id)
      response.headers["retry_after"] = "120"
      redirect_to :action => 'show', :id => job_id, :status=>303
   end
end
