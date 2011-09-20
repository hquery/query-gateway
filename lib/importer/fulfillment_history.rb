module Importer
  class FulfillmentHistory
    attr_accessor :prescription_number, :provider, :dispensing_pharmacy_location,
                  :dispense_date, :quantity_dispensed, :fill_number, :fill_status

    def to_hash
      fh = {}
      fh['prescriptionNumber'] = prescription_number if prescription_number.present?
      fh['provider'] = provider if provider.present?
      fh['dispensingPharmacyLocation'] = dispensing_pharmacy_location if dispensing_pharmacy_location.present?
      fh['dispenseDate'] = dispense_date if dispense_date.present?
      fh['quantityDispensed'] = quantity_dispensed if quantity_dispensed.present?
      fh['fillNumber'] = fill_number if fill_number.present?
      fh['fillStatus'] = fill_status if fill_status.present?
      
      fh
    end
  end
end