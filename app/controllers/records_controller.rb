class RecordsController < ApplicationController
  def create
    xml_file = params[:content].read
    doc = Nokogiri::XML(xml_file)
    doc.root.add_namespace_definition('cda', 'urn:hl7-org:v3')

    if params[:content_type]== 'c32'
	    pi = HealthDataStandards::Import::C32::PatientImporter.instance
			patient = pi.parse_c32(doc)
			patient.save!
			render :text => 'Patient imported', :status => 201

    elsif params[:content_type] == 'scoop_basic'
    	pi = HealthDataStandards::Import::ScoopBasic::PatientImporter.instance
    	patient = pi.parse_scoop_basic(doc)
    	patient.save!
    	render :text => 'Patient imported', :status => 201
    
    else
    	render :text => 'Patient not imported', :status => 422
    end
    
  end

end
