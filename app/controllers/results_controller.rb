class ResultsController < ApplicationController
  def index
    if stale?(:last_modified => Result.last_result_saved.utc)
      @results = Result.desc(:created_at)
      respond_to do |format|
        format.atom
      end
    end
  end

  def show
    @result = Result.find(params[:id])
    if stale?(:last_modified => @result.created_at.utc)
      render :json => @result
    end
  end
end
