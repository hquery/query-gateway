class JobLog
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  field :message, type: String

  embedded_in :query
end
