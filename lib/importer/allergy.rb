module Importer
  class Allergy < Importer::ExtendedEntry
    extended_attributes :reaction, :severity
  end
end