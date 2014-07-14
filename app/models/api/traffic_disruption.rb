class Api::TrafficDisruption < TrafficDisruption
  
  module Json
    Default = {}
    Map = {
      only: [:vehicles_affected, :lat, :lng],
      methods: [:source_name, :duration]
    }
  end
  
  scope :api_map_base, ->{ select('traffic_disruptions.vehicles_affected, traffic_disruptions.source, traffic_disruptions.lat, traffic_disruptions.lng, traffic_disruptions.started_at, traffic_disruptions.ended_at').with_location }
  scope :source_count_by_km, ->(km, source){ base_count.filter_by_km(km).filter_by_source(source) }
  scope :delivery_count_by_km, ->(km){ base_count.filter_by_km(km).with_delivery }
  
  def self.map_data(km_id, length_type)
    self.api_map_base.filter_by_km(km_id).filter_by_length_type(length_type)
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
  
  def self.api_source_for_kms(kms, source)
    kms.map do |km|
      self.source_count_by_km(km, source)[0][:num]
    end 
  end
  
  def self.api_delivery_percentage(kms)
    result = { deliveries: [], disruptions: [], kms: kms }
    kms.each do |km|
      disruption = self.delivery_count_by_km(km.id)[0][:num]
      no_disruption = km.deliveries_count - disruption
      result[:disruptions] << disruption
      result[:deliveries] << no_disruption
    end
    Api::Km.json_display = Api::Km::Json::Obstruction
    result
  end
  
end
