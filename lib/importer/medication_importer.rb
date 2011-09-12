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

        medication.route = extract_code(entry_element, "./cda:routeCode")
        medication.dose = extract_scalar(entry_element, "./cda:doseQuantity")
        medication.site = extract_code(entry_element, "./cda:approachSiteCode", 'SNOMED-CT')

        extract_dose_restriction(entry_element, medication)
        
        medication.product_form = extract_code(entry_element, "./cda:administrationUnitCode", 'NCI Thesaurus')
        medication.delivery_method = extract_code(entry_element, "./cda:code", 'SNOMED-CT')

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
        at['period'] = extract_scalar(administration_timing_element, "./cda:period")
        if at.present?
          medication.administration_timing = at
        end
      end
    end

    def extract_dose_restriction(parent_element, medication)
      dre = parent_element.at_xpath("./cda:maxDoseQuantity")
      if dre
        dr = {}
        dr['numerator'] = extract_scalar(dre, "./cda:numerator")
        dr['denominator'] = extract_scalar(dre, "./cda:denominator")
        medication.dose_restriction = dr
      end
    end
  end
end