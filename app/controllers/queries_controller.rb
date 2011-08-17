class QueriesController < ApplicationController
  def index
    if stale?(:last_modified => Query.last_query_update.utc)
      @queries = Query.desc(:updated_at)
      respond_to do |format|
        format.atom
      end
    end
  end

  def create
    map = params[:map].try(:read)
    reduce = params[:reduce].try(:read)
    @query = Query.new(:map => map, :reduce => reduce)
    if params[:filter]
      @query.filter_from_json_string(params[:filter].read)
    end
    if @query.save
      response.headers["Location"] = query_url(@query)
      render :text => "Query Created", :status => 201
    else
      render :text => @query.errors.full_messages.join(','), :status => 400
    end
  end

  def show
    @query = Query.find(params[:id])
    if stale?(:last_modified => @query.updated_at.utc)
      render :json => @query
    end
  end
end
