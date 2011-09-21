module Importer
  class Procedure < Importer::ExtendedEntry
    extended_attributes :performer, :site
    
    def to_hash
      encounter_hash = super
      
      encounter_hash
    end
  end
end