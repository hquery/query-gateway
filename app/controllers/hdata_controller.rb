class HdataController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.atom
    end
  end

  def root
    respond_to do |format|
      format.xml
    end
  end
end
