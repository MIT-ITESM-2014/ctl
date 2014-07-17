class Api::Delivery < Delivery
  
  Top = 3
  module Quartile
    Q1 = 0.10
    Q2 = 0.25
    Median = 0.5
    Q3 = 0.75
    Q4 = 0.90
  end
  
  module Json
    Default = {}
    Map = {
      only: [:vehicle_type, :delivering_company, :lat, :lng],
      methods: [:duration]
    }
  end
  
  scope :api_chart_ascending, ->{ order('shops.name ASC') }
  scope :api_map_base, ->{ select('deliveries.vehicle_type, deliveries.delivering_company, deliveries.started_at, deliveries.ended_at, deliveries.lat, deliveries.lng') }
  scope :count_per_vehicle_km, ->(km_id){ select('deliveries.vehicle_type').base_count.filter_by_km(km_id).group('deliveries.vehicle_type').order('NUM DESC') }
  scope :api_duration_by_km, ->(km_id){ select('deliveries.started_at, deliveries.ended_at').filter_by_km(km_id) }
  scope :api_count_by_km, ->(km_id){ base_count.filter_by_km(km_id) }
  
  def self.map_data(km_id, delivery_type)
    self.api_map_base.filter_by_km(km_id).filter_by_type(delivery_type)
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
  
  def delivery_duration
    (self.ended_at - self.started_at).to_i
  end
  
  def self.api_top_vehicles(km_id)
    self.count_per_vehicle_km(km_id).first(Top)
  end
  
  def self.api_top_vehicles_stats(km)
    { 
      name: "Top 3 vehicles in #{km.name}",
      id: "#{km.name.downcase}_#{km.id}",
      data: self.api_top_vehicles(km.id).map do |el|
        [el.vehicle_type, el[:num]]
      end
    }
  end
  
  def self.duration_quartiles(kms)
    result = { data: [], kms: kms }
    kms.each do |km|
      result[:data] << self.get_km_quartiles(km)
    end
    Api::Km.json_display = Api::Km::Json::Obstruction
    result
  end
  
  def self.get_km_quartiles(km)
    result = []
    duration = self.api_duration_by_km(km.id)
    unless duration.nil?
     values = duration.map do |el|
      el.delivery_duration
     end
     p values
     result = self.get_quartiles(values)
    end
    result
  end
  
  protected
  
  def self.get_quartiles(array)
    result = []
    array.sort!
    result << self.get_quartile(array, Quartile::Q1)
    result << self.get_quartile(array, Quartile::Q2)
    result << self.get_quartile(array, Quartile::Median)
    result << self.get_quartile(array, Quartile::Q3)
    result << self.get_quartile(array, Quartile::Q4)
    result
  end
  
  def self.get_quartile(array, percentile)
    result = 0
    unless percentile == 0.0
      result = array[(array.length * percentile).ceil - 1]
    else
      result = array[0]
    end
    result / 60
  end
  
end
