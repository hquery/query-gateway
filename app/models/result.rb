class Result
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  
  belongs_to :query
  
  def self.last_result_saved
    latest_result = desc(:created_at).first
    if latest_result
      latest_result.created_at
    else
      Time.new(2011, 8, 12) # hardcode to old date if there are no results in the system
    end
  end
end