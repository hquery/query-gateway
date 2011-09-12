module Importer
  class MedicationImporter < QME::Importer::SectionImporter
    include CoreImporter
    
    def initialize
      @entry_xpath = "//cda:section[cda:templateId/@root='2.16.840.1.113883.3.88.11.83.112']/cda:entry/cda:substanceAdministration"
      @code_xpath = "./cda:consumable/cda:manufacturedProduct/cda:manufacturedMaterial/cda:code"
      @description_xpath = "./cda:consumable/cda:manufacturedProduct/cda:manufacturedMaterial/cda:code/cda:originalText/cda:reference[@value]"
      
      @check_for_usable = true               # Pilot tools will set this to false
      @id_map = {}
    end
    
    # Traverses that HITSP C32 document passed in using XPath and creates an Array of Entry
    # objects based on what it finds                          
    # @param [Nokogiri::XML::Document] doc It is expected that the root node of this document
    #        will have the "cda" namespace registered to "urn:hl7-org:v3"
    #        measure definition
    # @return [Array] will be a list of Entry objects
    def create_entries(doc,id_map = {})
      @id_map = id_map
      medication_list = []
      entry_elements = doc.xpath(@entry_xpath)
      entry_elements.each do |entry_element|
        medication = Medication.new
        extract_codes(entry_element, medication)
        extract_dates(entry_element, medication)
        extract_description(entry_element, medication, id_map)
        
        if medication.description.present?
          medication.free_text_sig = medication.description
        end
        
        extract_administration_timing(entry_element, medication)
        extract_route(entry_element, medication)
        
        if @check_for_usable
          medication_list << medication if medication.usable?
        else
          medication_list << medication_list
        end
      end
      medication_list
    end
    
    private
    
    def extract_administration_timing(parent_element, medication)
      administration_timing_element = parent_element.at_xpath("./cda:effectiveTime[2]")
      if administration_timing_element
        at = {}
        if administration_timing_element['institutionSpecified']
          at['institutionSpecified'] = administration_timing_element['institutionSpecified'].to_boolean
        end
        period_element = administration_timing_element.at_xpath("./cda:period")
        if period_element
          at['period'] = {'unit' => period_element['unit'], 'value' => period_element['value'].to_i}
        end
        if at.present?
          medication.administration_timing = at
        end
      end
    end
    
    def extract_route(parent_element, medication)
      code = extract_code(parent_element, "./cda:routeCode")
      medication.route = code if code
    end
  end
end