class RecordsController < ApplicationController
  def create
    xml_file = params[:content].read
    doc = Nokogiri::XML(xml_file)
    root_element_name = doc.root.name
    if root_element_name == 'ClinicalDocument'
        doc.root.add_namespace_definition('cda', 'urn:hl7-org:v3')
        #document_type = doc.at_xpath('/cda:ClinicalDocument/cda:templateId')['root']
        document_type = doc.at_xpath('/cda:ClinicalDocument/cda:realmCode')['code']
        # check the specific flavour of cda
        # E2E
        if document_type == 'CA'
            pi = HealthDataStandards::Import::E2E::PatientImporter.instance
            patient = pi.parse_e2e(doc)
            patient_id = patient.medical_record_number
            # By specifying the _id field we create a new document when a record
            # with that _id field doesn't already exist in the collection.  If
            # a record with the same _id field already exists, it is updated
            # with the new document.  For details see
            # http://docs.mongodb.org/manual/reference/method/db.collection.save/
            if !patient_id.nil? && !patient_id.empty?
              patient[:_id] = patient_id
            end
            patient.save!
            render :text => 'E2E Document imported', :status => 201
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
