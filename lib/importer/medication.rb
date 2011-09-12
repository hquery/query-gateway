module Importer
  class Medication < Importer::ExtendedEntry
    extended_attributes :administration_timing, :free_text_sig, :dose, :brand_name,
                        :type_of_medication, :status_of_medication, :fulfillment_history,
                        :order_information, :route, :site, :dose_restriction,
                        :fulfillment_instructions, :indication, :product_form,
                        :vehicle, :reaction, :delivery_method, :patient_instructions
  end
end