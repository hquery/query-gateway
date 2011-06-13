class RecordsController < ApplicationController
  def create
    xml_file = params[:content].read
    doc = Nokogiri::XML(xml_file)
    doc.root.add_namespace_definition('cda', 'urn:hl7-org:v3')
    pi = QME::Importer::PatientImporter.instance
    patient = pi.parse_c32(doc)
    
    Mongoid.master['records'] << patient
    render :text => 'Patient imported', :status => 201
  end

end
