# This file is used to load enhancements to the Quality Measure Engine for full C32
# importing

require 'importer/result'
require 'importer/result_importer'

pi = QME::Importer::PatientImporter.instance

# Crack open the PI and replace the result importer... slightly evil
pi.instance_eval do
  @section_importers[:results] = Importer::ResultImporter.new
end

QME::Importer::CodeSystemHelper::CODE_SYSTEMS["2.16.840.1.113883.5.83"] = "HITSP C80 Observation Status"

