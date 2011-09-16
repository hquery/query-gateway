module Importer
  class Encounter < Importer::ExtendedEntry
    extended_attributes :performer, :facility, :reason, :admit_type, :discharge_disp
    
    def to_hash
      encounter_hash = super
      
      encounter_hash
    end
  end
end