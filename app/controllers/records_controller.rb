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
        if document_type == 'CA' || document_type == 'CA-BC'
            pi = HealthDataStandards::Import::E2E::PatientImporter.instance
            patient = pi.parse_e2e(doc)
            # By specifying the _id field we create a new document when a record
            # with that _id field doesn't already exist in the collection.  If
            # a record with the same _id field already exists, it is updated
            # with the new document.  For details see
            # http://docs.mongodb.org/manual/reference/method/db.collection.save/
            patient_id = OpenSSL::Digest::SHA224.new
            if !patient.medical_record_number.nil? && !patient.medical_record_number.empty?
              patient_id << patient.medical_record_number
              patient.medical_record_number = ""   # remove HIN
            end
            if !patient.first.nil? && !patient.first.empty?
              patient_id << patient.first
              patient.first = ""                   # remove first name
            end
            if !patient.last.nil? && !patient.last.empty?
              patient_id << patient.last
              patient.last = ""                    # remove last name
            end
            if !patient.birthdate.nil? && !patient.birthdate.to_s.empty?
              patient_id << patient.birthdate.to_s
            end
            if !patient.gender.nil? && !patient.gender.empty?
              patient_id << patient.gender
            end
            patient[:_id] = Base64.strict_encode64(patient_id.digest)
            # patient.save! isn't working as documented, don't know why
            # appears that it should but upsert does what we need.  See
            #  http://mongoid.org/en/mongoid/docs/persistence.html
            patient.upsert
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
