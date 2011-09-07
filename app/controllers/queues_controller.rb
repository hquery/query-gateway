require 'query_job'
require 'job_stats'

class QueuesController < ApplicationController
 
  def index
  end
 
  def create
    map = params[:map].try(:read)
    reduce = params[:reduce].try(:read)
    @query = Query.new(:map => map, :reduce => reduce)
    if params[:filter]
      @query.filter_from_json_string(params[:filter].read)
    end
    @query.save!
    job = @query.job
    redirect_til_done(@query.id)
  end

  def show
    begin
      @query = Query.find(params[:id])
      case @query.status
      when :failed
        render :text => @query.job_logs.last.message, :status=>500
      when :complete
        render :json => @query.result
      when :canceled
        render :text => "Job Canceled", :status => 404
      else
        redirect_til_done(@query.id)
      end
    rescue Mongoid::Errors::DocumentNotFound
      render :text => "Job not Found", :status => 404
    end
  end

  def destroy
    @query = Query.find(params[:id])
    QueryJob.cancel_job(@query.delayed_job_id.to_s)
    render :text => "Job Canceled"
  end

  def job_status
    begin
      @query = Query.find(params[:id])
      render :json=> {:logs => @query.job_logs, :status => @query.status}
    rescue Mongoid::Errors::DocumentNotFound
      render :text => "Job not Found", :status => 404
    end
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
end
