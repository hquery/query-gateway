class RecordsController < ApplicationController
  def create

    xml_file = params[:content].read

    doc = Nokogiri::XML(xml_file)

    root_element_name = doc.root.name
    
    if root_element_name == 'ClinicalDocument'
        doc.root.add_namespace_definition('cda', 'urn:hl7-org:v3')

        document_type = doc.at_xpath('/cda:ClinicalDocument/cda:templateId')['root']

        # check the specific flavour of cda
        # scoop basic
        if document_type == 'scoop_basic'
            pi = HealthDataStandards::Import::ScoopBasic::PatientImporter.instance
            patient = pi.parse_scoop_basic(doc)
            patient.save!
            render :text => 'Scoop Basic Patient imported', :status => 201
        
        # C32
        else
            pi = HealthDataStandards::Import::C32::PatientImporter.instance
            patient = pi.parse_c32(doc)
            patient.save!
            render :text => 'C32 Patient imported', :status => 201
        
        end
    
    else
        render :text => 'Unknown XML Format', :status => 400
    end
    
  end

end
