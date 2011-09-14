module Importer
  class EncounterImporter < QME::Importer::SectionImporter
    include CoreImporter
    
    def initialize
      @entry_xpath = "//cda:section[cda:templateId/@root='2.16.840.1.113883.3.88.11.83.127']/cda:entry/cda:encounter"
      @code_xpath = "./cda:code"
      @description_xpath = "./cda:code/cda:originalText/cda:reference[@value] | ./cda:text/cda:reference[@value] "
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
      encounter_list = []
      entry_elements = doc.xpath(@entry_xpath)
      entry_elements.each do |entry_element|
        encounter = Encounter.new
        extract_codes(entry_element, encounter)
        extract_dates(entry_element, encounter)
        extract_description(entry_element, encounter, id_map)
        if @check_for_usable
          encounter_list << encounter if encounter.usable?
        else
          encounter_list << encounter
        end
        extract_performer(entry_element, encounter)
      end
      encounter_list
    end
    
    private
    
    def extract_performer(parent_element, encounter)
      performer_element = parent_element.at_xpath("./cda:performer")
      encounter.performer = import_actor(performer_element) if performer_element
    end

  end
end