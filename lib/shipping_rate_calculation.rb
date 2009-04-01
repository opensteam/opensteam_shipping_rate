# Shipping rate calculation module
module ShippingRateCalculation

  # calculate the shipping rate for the global settings (set through Opensteam::Config[:shipping_strategy]
  def calculate_shipping_rate attr = {} 
    send( "shipping_rate_#{Opensteam::Config[:shipping_strategy]}", attr )
  end


  # set shipping_rate and update total_price
  # ! does not save the object !
  def set_shipping_rate!
    returning( self ) do |s|
      s.shipping_rate = ( r = calculate_shipping_rate ).is_a?( Array ) ? r.sum : r
      s.total_price += s.shipping_rate
    end
    #        self.update_attribute( :shipping_rate, ( r = calculate_shipping_rate ).is_a?( Array ) ? r.sum : r )
  end



  def shipping_rate_per_order attr
    set_shipping_attributes( attr )

    ShippingRateGroup.find_by_name( attr[:group_name] ).rate_for( attr )
  end



  def shipping_rate_per_item attr
    set_shipping_attributes( attr )

    self.items.collect { |i|
      ShippingRateGroup.find_by_name( i.shipping_rate_group ).rate_for( attr ) rescue 0.0
    }
  end


  def set_shipping_attributes( attr )
    attr[:payment_type] = self.payment_type unless attr[:payment_type]
    attr[:shipping_method] = self.shipping_type unless attr[:shipping_method]
    attr[:country] = self.shipping_address.country unless attr[:country]
    attr[:group_name] = Opensteam::Config[:shipping_rate_group_default] unless attr[:group_name]
  end

  private :set_shipping_attributes

end