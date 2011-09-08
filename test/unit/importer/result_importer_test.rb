require 'test_helper'

class ResultImporterTest < ActiveSupport::TestCase
  def test_result_importing
    doc = Nokogiri::XML(File.new('test/fixtures/NISTExampleC32.xml'))
    doc.root.add_namespace_definition('cda', 'urn:hl7-org:v3')
    pi = QME::Importer::PatientImporter.instance
    patient = pi.create_c32_hash(doc)
    
    result = patient[:results][0]
    assert_equal 'N', result.interpretation['code']
    assert_equal 'HITSP C80 Observation Status', result.interpretation['codeSystem']
    assert_equal 'completed', result.status
  end
end