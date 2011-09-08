module Importer
  class Immunization < Importer::ExtendedEntry
    extended_attributes :refusal_ind, :performer, :refusal_reason
    
    def to_hash
      immunization_hash = super
      
      immunization_hash['administeredDate'] = as_point_in_time
      
      immunization_hash
    end
  end
end