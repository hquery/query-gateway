class Query
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :map, :type => String
  field :reduce, :type => String
  field :filter, :type => Hash
  
  validates_presence_of :map
  validates_presence_of :reduce
  
  def has_been_updated?
    created_at != updated_at
  end
  
  def filter_from_json_string(json_string)
    if json_string.present?
      self.filter = ActiveSupport::JSON.decode(json_string.strip)
    end
  end
end
