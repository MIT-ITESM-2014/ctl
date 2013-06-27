class Admin::Km < Km
  
  scope :list, ->{ select("kms.id, kms.tracks_count, kms.traffic_counts_count, kms.traffic_disruptions_count, kms.street_data_count, kms.parking_restrictions_count, kms.shops_count, kms.deliveries_count, kms.name, kms.captured_at") }
  
  def as_json(opts = {})
    super(opts.merge(methods: [:c_at]))
  end
  
  def captured_at=(val)
    write_attribute(:captured_at, time_val(val))
  end
  
  def list_elements(base)
    base.filter_by_km(self.id)
  end
  
  def find_track_by_id(id)
    Admin::Track.base.filter_by_km(self.id).filter_by_id(id).first
  end
  
  def find_traffic_count_by_id(id)
    Admin::TrafficCount.filter_by_km(self.id).filter_by_id(id).first
  end
  
  def find_traffic_disruption_by_id(id)
    Admin::TrafficDisruption.filter_by_km(self.id).filter_by_id(id).first
  end
  
  def find_street_data_by_id(id)
    Admin::StreetData.filter_by_km(self.id).filter_by_id(id).first
  end
  
  def find_shop_by_id(id)
    Admin::Shop.filter_by_km(self.id).filter_by_id(id).first
  end
  
  def find_delivery_by_id(id)
    Admin::Delivery.filter_by_km(self.id).filter_by_id(id).first
  end
  
  
end
