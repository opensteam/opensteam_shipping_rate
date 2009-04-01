# Model for ShippingRate Additions depending on the payment_type
class ShippingPaymentModification < ActiveRecord::Base
  self.table_name = "shipping_payment_additions"
  
  belongs_to :shipping_rate_group,
    :class_name => "ShippingRateGroup"
  
  validates_uniqueness_of :payment_type, :scope => [ :shipping_rate_group_id ]
  
end