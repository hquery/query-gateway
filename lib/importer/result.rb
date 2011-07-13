module Importer
  class Result < QME::Importer::Entry
    attr_accessor :reference_range, :interpretation_code, :interpretation_code_system_name
    
    def to_hash
      result_hash = super
      result_hash['referenceRange'] = reference_range if reference_range
      
      if interpretation_code
        ic_hash = {'code' => interpretation_code,
                   'codeSystemName'  => interpretation_code_system_name}
        result_hash['interpretation'] = ic_hash
      end
      
      result_hash
    end
  end
end