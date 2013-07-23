class Delivery < ActiveRecord::FmxBase

  include BlockStreetable
  include DateParsable
  include Kmable
  include Peakable
  include Localizable
  include Durable
  
  module DeliveryType
    Delivery = 'D'
    Pickup = 'P'
    Both = 'B'
    
    List = {
      Delivery => {
        name: I18n.t('app.model.delivery.delivery_type.delivery')
      },
      Pickup => {
        name: I18n.t('app.model.delivery.delivery_type.pickup')
      },
      Both =>  {
        name: I18n.t('app.model.delivery.delivery_type.both')
      }
    }
    
    def self.keys
      @@keys ||= List.keys
    end
    
  end
  
  scope :base, ->{ select("deliveries.id, deliveries.km_id, deliveries.street_id, deliveries.shop_id, deliveries.started_at, deliveries.ended_at, deliveries.vehicle_type, deliveries.delivering_company, deliveries.product_delivered, deliveries.refrigerated_vehicle, deliveries.boxes_delivered, deliveries.delivery_type, deliveries.with_equipment, deliveries.number_of_trips, deliveries.notes, deliveries.lat, deliveries.lng") }
  scope :base_count, ->{ select("COUNT(deliveries.id) as num") }
  scope :min_base, ->{ select('MIN(deliveries.started_at) as min_time').order(nil) }
  scope :max_base, ->{ select('MAX(deliveries.ended_at) as max_time').order(nil) }
  scope :filter_by_id, ->(id){ where(id: id) }
  scope :filter_by_shop, ->(shop_id){ where(shop_id: shop_id) }
  scope :filter_by_type, ->(delivery_type){ where(delivery_type: delivery_type) }
  
  validates :started_at, presence: true
  validates :ended_at, presence: true
  validates :vehicle_type, presence: true, length: { maximum: 30 }
  validates :delivering_company, presence: true, length: { maximum: 50 }
  validates :product_delivered, presence: true, length: { maximum: 50 }
  validates :refrigerated_vehicle, numericality: { only_integer: true }, inclusion: { in: self.boolean_int }, allow_blank: true
  validates :boxes_delivered, numericality: { only_integer: true }, allow_blank: true
  validates :delivery_type, presence: true, length: { is: 1 }, inclusion: { in: DeliveryType.keys }
  validates :with_equipment, numericality: { only_integer: true }, inclusion: { in: self.boolean_int }, allow_blank: true
  validates :number_of_trips, numericality: { only_integer: true }, allow_blank: true
  validates :notes, length: { maximum: 300 }
  validate :valid_shop_id
  
  after_create :add_deliveries_count
  before_destroy :substract_deliveries_count
  
  def shop
    @shop ||= Shop.find_by_id(self.shop_id)
  end
  
  def valid_shop_id
    errors.add(:shop_id, I18n.t('activerecord.errors.messages.not_found')) if self.shop_id.nil?
  end
  
  def shop_id=(val)
    shop = Shop.find_by_shop_id(val)
    write_attribute(:shop_id, shop.id) unless shop.nil?
  end
  
  def s_at
    @s_at ||= ->{
      (self.started_at.to_i * 1000) unless self.started_at.nil?
    }.call
  end
  
  def e_at
    @e_at ||= ->{
      (self.ended_at.to_i * 1000) unless self.ended_at.nil?
    }.call
  end
  
  def started_at=(val)
    write_attribute(:started_at, date_time_val(val))
  end
  
  def ended_at=(val)
    write_attribute(:ended_at, date_time_val(val))
  end
  
  def delivery_type=(val)
    write_attribute(:delivery_type, upcase(val))
  end
  
  protected
  
  def add_deliveries_count
    curr_count = self.shop.deliveries_count.to_i
    self.shop.deliveries_count = curr_count + 1
    self.shop.save
  end
  
  def substract_deliveries_count
    curr_count = self.shop.deliveries_count.to_i
    self.shop.deliveries_count = curr_count - 1
    self.shop.save
  end
  
  def self.peak_field
    "started_at"
  end
  
  def location_field
    @location_field ||= "started_at"
  end
  
  
end