class Api::Km < Km
  
  module Json
    Default = {}
    Show = {
      methods: [:full_name]
    }
  end
  
  scope :filter_base, ->{ select('kms.id, kms.name') }
  scope :api_base, ->{ select('kms.id, kms.name, kms.shops_count, kms.public_meter_length, kms.dedicated_meter_length, kms.peak_deliveries, kms.peak_traffic, kms.peak_disruptions, kms.lat, kms.lng, kms.street_lat, kms.street_lng').with_city }
  
  def self.json_display
    @@json_display ||= Json::Default
  end
  
  def self.json_display=(val)
    @@json_display = val
  end
  
  def as_json(opts = {})
    super(opts.merge(self.class.json_display))
  end
  
  def self.find_api_base_by_id(id)
    self.api_base.filter_active.filter_by_id(id).first
  end
  
  
end