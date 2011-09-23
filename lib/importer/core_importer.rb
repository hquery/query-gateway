module Importer
  module CoreImporter
    def import_actor(actor_element)
      actor_hash = {}
      addresses = actor_element.xpath("./cda:assignedEntity/cda:addr").try(:map) {|ae| import_address(ae)}
      telecoms = actor_element.xpath("./cda:assignedEntity/cda:telecom").try(:map) {|te| import_telecom(te)}
      person_element = actor_element.at_xpath("./cda:assignedEntity/cda:assignedPerson")
      if person_element
        actor_hash['person'] = import_person(person_element)
        actor_hash['person']['addresses'] = addresses
        actor_hash['person']['telecoms'] = telecoms
      end
      organization_element = actor_element.at_xpath("./cda:assignedEntity/cda:assignedOrganization")
      if organization_element
        actor_hash['organization'] = import_organization(organization_element)
      end
      
      actor_hash
    end
    
    def import_person(person_element)
      person_hash = {}
      name_element = person_element.at_xpath("./cda:name")
      person_hash['name'] = name_element.try(:text)
      person_hash['first'] = name_element.at_xpath("./cda:given").try(:text)
      person_hash['last'] = name_element.at_xpath("./cda:family").try(:text)
      person_hash
    end
    
    def import_address(address_element)
      address_hash = {}
      address_hash['streetAddress'] = [address_element.at_xpath("./cda:streetAddressLine").try(:text)]
      address_hash['city'] = address_element.at_xpath("./cda:city").try(:text)
      address_hash['stateOrProvince'] = address_element.at_xpath("./cda:state").try(:text)
      address_hash['zip'] = address_element.at_xpath("./cda:postalCode").try(:text)
      address_hash['country'] = address_element.at_xpath("./cda:country").try(:text)
      address_hash
    end
    
    def import_telecom(telecom_element)
      telecom_hash = {}
      telecom_hash['value'] = telecom_element['value']
      telecom_hash['use'] = telecom_element['use']
      telecom_hash
    end
    
    def import_organization
      # TODO: Implement when the Patient API has an implementation of
      # organization
    end
    
    def extract_code(parent_element, code_xpath, code_system=nil)
      code_element = parent_element.at_xpath(code_xpath)
      code_hash = nil
      if code_element
        code_hash = {'code' => code_element['code']}
        if code_system
          code_hash['codeSystem'] = code_system
        else
          code_hash['codeSystemOid'] = code_element['codeSystem']
          code_hash['codeSystem'] = QME::Importer::CodeSystemHelper.code_system_for(code_hash['codeSystemOid'])
        end
      end

      code_hash
    end
    
    def extract_scalar(parent_element, scalar_xpath)
      scalar_element = parent_element.at_xpath(scalar_xpath)
      if scalar_element
        {'unit' => scalar_element['unit'], 'value' => scalar_element['value'].to_i}
      else
        nil
      end
    end
  end
end