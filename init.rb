# Include hook code here


Opensteam::Container::Base.class_eval do
  include ShippingRateCalculation
end

Opensteam::Extension.register :shipping_rates do
  backend :config
end

