class Api::Shop < Shop
  
  module Json
    Default = {}
    Map = {
      only: [:name, :has_loading_area, :deliveries_count, :lat, :lng],
      methods: [:f_length]
    }
    Heat = {
      only: [:lat, :lng],
      methods: [:f_length]
    }
  end
  
  scope :api_chart_base, ->{ select('shops.id, shops.name').with_deliveries.ascending }
  scope :api_map_base, ->{ select('shops.name, shops.has_loading_area, shops.deliveries_count, shops.front_length, shops.lat, shops.lng') }
  
  def self.map_data(km_id, shop_type)
    self.api_map_base.filter_by_km(km_id).filter_by_type(shop_type)
  end
  
  def self.heat_data(km_id)
    self.api_map_base.filter_by_km(km_id)
  end
  
  def self.json_display
    @@json_display ||= Json::Default
  end
  
  def self.json_display=(val)
    @@json_display = val
  end
  
  def as_json(opts = {})
    super(opts.merge(self.class.json_display))
  end
  
end
