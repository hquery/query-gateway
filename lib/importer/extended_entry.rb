module Importer
  # Allows for the creation of extened C32 Entry Objects. This class will allow for
  # the creation of attributes that are properly serialized when to_hash is called
  # on them.
  class ExtendedEntry < QME::Importer::Entry
    
    # Macro for defining extended attributes
    def self.extended_attributes(*extended_attributes)
      @extended_attributes ||= []
      @extended_attributes = @extended_attributes.concat(extended_attributes)
      extended_attributes.each do |extended_attribute|
        attr_accessor extended_attribute
      end
    end

    # Writes attributes out to a hash, with String keys that are in
    # lower camel case. So an attribute called "bacon_lover" would
    # become "baconLover"
    def to_hash
      entry_hash = super
      self.class.extended_attribute_list.each do |extended_attribute|
        attribute_value = self.send(extended_attribute)
        if attribute_value.present?
          hash_property_name = extended_attribute.to_s.camelize(:lower)
          if attribute_value.respond_to?(:to_hash)
            entry_hash[hash_property_name] = attribute_value.to_hash
          else
            entry_hash[hash_property_name] = attribute_value
          end
        end
      end
      
      entry_hash
    end
    
    private
    
    def self.extended_attribute_list
      @extended_attributes
    end
  end
end