require 'query_job'
require 'job_stats'
require 'query_utilities'
class QueuesController < ApplicationController
  
  include QueryUtilities
 
  def index

  end
 
  def create
    map=params[:map].read
    reduce = params[:reduce].read
    filter = read_filter params[:filter].read if params[:filter]
    job = QueryJob.submit(map,reduce,filter)
    redirect_til_done(job.id)
  end

  def show
    job_id = params[:id]
    jlog = JobLog.first({conditions:{job_id: job_id}})
    status= (jlog) ? jlog.status.to_sym : :not_found
    case status
    when :failed
      render :text=>QueryJob.find_job(job_id).last_error, :status=>500
    when :success
      render :json=>QueryJob.job_results(job_id)
    when :not_found
      render :text=>"Job not Found", :status=>404
    when :canceled
      render :text=>"Job Canceled", :status=>404
    else
      redirect_til_done(job_id)
    end

  end
  
  def destroy
     job_id = params[:id]
     QueryJob.cancel_job(job_id)
     render :text=>"Job Canceled"
  end
  
  
  def job_status
     job_id = params[:id]
     jlog = JobLog.first({conditions:{job_id: job_id}})
     status= (jlog) ? jlog.status : :not_found
     if status == :not_found
       render :text=>"Job not Found", :status=>404
       return
     end
     render :json=>{:logs => jlog.messages, :status =>jlog.status}    
  end

  def server_status
    render :json => JobStats.stats  
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
