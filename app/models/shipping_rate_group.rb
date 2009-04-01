# Model for Shipping Rate Groups
class ShippingRateGroup < ActiveRecord::Base
  has_many :shipping_rates,
  :class_name => 'RegionShippingRate',
  :dependent => :destroy

  has_many :zones,
  :class_name => 'Opensteam::System::Zone',
  :through => :shipping_rates

  has_many :payment_additions,
  :class_name => 'ShippingPaymentModification'


  validates_presence_of :name
  validates_uniqueness_of :name

  validates_associated :shipping_rates
  validates_associated :payment_additions

  after_update :save_shipping_rates, :save_payment_additions


  def rate_for( attr = {} )
    conditions = {
      "zones.country_name" => attr[:country] || Opensteam::Config[:default_country],
      "region_shipping_rates.shipping_method" => attr[:shipping_method] || Opensteam::Config[:shipping_method_default]
    }
    #        conditions = {}
    #        conditions["zones.country_name"] = attr[:country] || Opensteam::Config[:default_country]
    #        conditions["region_shipping_rates.shipping_method"] = attr[:shipping_method] || Opensteam::Config[:shipping_method_default]

    srate = shipping_rates.find( :first, :include => :zone, :conditions => conditions )

    rate = unless srate
      shipping_disabled ? 0.0 : master_rate.to_f
    else
      srate.rate
    end

    rate += get_payment_additions( attr[:payment_type] ) if attr[:payment_type]

    rate
  end





  private

  def get_payment_additions( payment_type )
    if ( pa = payment_additions.find(:first, :conditions => { :payment_type => payment_type } ) )
      pa.amount
    else
      0.0
    end
  end



  def new_payment_additions=( pa )
    pa.each do |r|
      payment_additions.build( r )
    end
  end


  def existing_payment_additions=( pa )
    payment_additions.reject(&:new_record?).each do |paddition|
      attributes = pa[ paddition.id.to_s ]
      if attributes
        paddition.attributes = attributes
      else
        payment_additions.delete( paddition )
      end
    end
  end


  def new_rates=( rates )
    rates.each do |r|
      shipping_rates.build( r )
    end
  end

  def existing_rates=( rates )
    shipping_rates.reject(&:new_record?).each do |rate|
      attributes = rates[ rate.id.to_s ]
      if attributes
        rate.attributes = attributes
      else
        shipping_rates.delete( rate )
      end
    end

  end



  def validate
    if shipping_rates.empty?
      if self.master_rate.blank? && !self.shipping_disabled
        errors.add_to_base( "Either add Shipping Rates or define a default rate!" )
        errors.add( :shipping_rates, "Cannot be empty!" )
        errors.add( :master_rate, "Cannot be empty!" )
        errors.add( :shipping_disabled, "" )
      end
    end
  end

  def save_shipping_rates
    shipping_rates.each { |s| s.save(false) }
  end

  def save_payment_additions
    payment_additions.each { |s| s.save(false) }
  end



end
