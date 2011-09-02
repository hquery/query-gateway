module Importer
  class Immunization < QME::Importer::Entry
    attr_accessor :refusal, :performer, :refusal_reason
    
    def to_hash
      immunization_hash = super
      
      if refusal.present?
        immunization_hash['refusalInd'] = refusal
      end
      
      if refusal_reason.present?
        immunization_hash['refusalReason'] = refusal_reason
      end
      
      immunization_hash['administeredDate'] = as_point_in_time
      
      if performer
        immunization_hash['performer'] = performer
      end
      
      immunization_hash
    end
  end
end