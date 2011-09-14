module Importer
  class OrderInformation
    attr_accessor :order_number, :fills, :quantity_ordered, :order_expiration_date_time,
                  :order_date_time

    def to_hash
      oi = {}
      oi['orderNumber'] = order_number if order_number.present?
      oi['fills'] = fills if fills.present?
      oi['quantityOrdered'] = quantity_ordered if quantity_ordered.present?
      oi['quantityExpirationDateTime'] = order_expiration_date_time if order_expiration_date_time.present?
      oi['orderDateTime'] = order_date_time if order_date_time.present?
      
      oi
    end
  end
end