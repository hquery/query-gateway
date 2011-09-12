require 'test_helper'

class MedicationImporterTest < ActiveSupport::TestCase
  def test_medication_importing
    doc = Nokogiri::XML(File.new('test/fixtures/NISTExampleC32.xml'))
    doc.root.add_namespace_definition('cda', 'urn:hl7-org:v3')
    pi = QME::Importer::PatientImporter.instance
    patient = pi.create_c32_hash(doc)
    
    medication = patient[:medications][0]
    assert medication.codes['RxNorm'].include? '307782'
    assert_equal 6, medication.administration_timing['period']['value']
    assert_equal 'IPINHL', medication.route['code']
    assert_equal 2, medication.dose['value']
    assert_equal '127945006', medication.site['code']
    assert_equal 'SNOMED-CT', medication.site['codeSystem']
    assert_equal 5, medication.dose_restriction['numerator']['value']
    assert_equal 10, medication.dose_restriction['denominator']['value']
    assert_equal '415215001', medication.product_form['code']
    assert_equal '334980009', medication.delivery_method['code']
    assert_equal '73639000', medication.type_of_medication['code']
  end
end