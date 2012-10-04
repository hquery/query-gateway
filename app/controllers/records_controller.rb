class RecordsController < ApplicationController
  def create

    xml_file = params[:content].read

    doc = Nokogiri::XML(xml_file)

    root_element_name = doc.root.name
    
    if root_element_name == 'ClinicalDocument'
        doc.root.add_namespace_definition('cda', 'urn:hl7-org:v3')

        ##document_type = doc.at_xpath('/cda:ClinicalDocument/cda:templateId')['root']
        document_type = doc.at_xpath('/cda:ClinicalDocument/cda:realmCode')['code']

        # check the specific flavour of cda
        # E2E
        if document_type == 'CA'
            pi = HealthDataStandards::Import::E2E::PatientImporter.instance
            patient = pi.parse_e2e(doc)
            patient.save!
            render :text => 'Scoop E2E Document imported', :status => 201
        
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

  def destroy
    Record.delete_all

    render :text => 'All patients were deleted', :status => 200
    
  end

end
