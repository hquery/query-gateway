module Importer
  class Immunization < QME::Importer::Entry
    attr_accessor :refusal, :performer
    
    def to_hash
      immunization_hash = {}
      
      unless refusal.nil?
        immunization_hash['refusal'] = refusal
      end
      
      immunization_hash['medicationInformation'] = {'codedProducts' => codes}
      immunization_hash['administeredDate'] = as_point_in_time
      
      immunization_hash
    end
  end
end