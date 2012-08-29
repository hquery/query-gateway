class PMNRequest
  include Mongoid::Document
  include Mongoid::Timestamps
  
  has_one :query, :inverse_of => :request

  field :doc_id, type: String
  field :mime_type, type: String
  field :size, type: Integer
  field :content, type: String
end
