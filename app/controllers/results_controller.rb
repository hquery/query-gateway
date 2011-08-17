class ResultsController < ApplicationController
  def index
    @results = Result.desc(:created_at)
    respond_to do |format|
      format.atom
    end
  end

  def show
    @result = Result.find(params[:id])
    render :json => @result
  end
end
