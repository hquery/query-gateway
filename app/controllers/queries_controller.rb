require 'query_job'
class QueriesController < ApplicationController
  
 
  def index
    @jobs = QueryJob.all_jobs
  end

  def create
    map =params[:map]
    reduce = params[:reduce]
    job = QueryJob.submit(map,reduce)
     redirect_til_done(job.id)
  end


  def show
    job_id = params[:id]
    case  QueryJob.job_status(job_id)
    when :failed
      render 
    when :completed
      render :json=>QueryJob.job_results(job_id)
    else
      redirect_til_done(job_id)
    end

  end

   private 
   def redirect_til_done(job_id)
      response.headers["Retry-After"] = 120
      redirect_to :action => 'show', :id => job_id, :status=>303
   end
end
