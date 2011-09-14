module Importer
  class Encounter < Importer::ExtendedEntry
    extended_attributes :performer
    
    def to_hash
      encounter_hash = super
      
      encounter_hash
    end
  end
end