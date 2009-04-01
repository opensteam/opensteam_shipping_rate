# Model for ShippingRate depending on Region (Zone, Country, .. )
class RegionShippingRate < ActiveRecord::Base

  belongs_to :group,
    :class_name => 'ShippingRateGroup'

  belongs_to :zone,
    :class_name => 'Opensteam::System::Zone'


  ## named scopes
  
  # find all by country-name and shipping-method-name
  named_scope :by_country_and_shipping_method, lambda { |country, sm|
    { :include => :zone,
      :conditions => { "zones.country_name" => country, :shipping_method => sm }
    }
  }

  # find all by country-name
  named_scope :by_country_name, lambda { |country_name|
    { :include => :zone, :conditions => { "zones.country_name" => country_name } }
  }

  # find all by shipping-method-name
  named_scope :by_shipping_method, lambda { |shipping_method|
    { :conditions => { :shipping_method => shipping_method } }
  }

end
