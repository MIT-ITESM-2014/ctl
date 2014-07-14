class Api::StreetData < StreetData

  Lanes = 2

  scope :parking_count_by_lane_km, ->(id, lane){ base_count.filter_by_km(id).filter_by_parking_lanes(lane) }

  def self.api_lanes_bays_distribution(kms)
    result = { lanes: {}, bays: {}, kms: kms }
    result[:lanes] = self.api_lanes_distribution(kms)
    result[:bays] = Api::Street.api_bays_distribution(kms)
    Api::Km.json_display = Api::Km::Json::Obstruction
    result
  end
  
  protected
  
  def self.api_lanes_distribution(kms)
    lanes = {}
    (0..Lanes).each do |lane|
      tmp = []
      kms.each do |km|
        count = self.parking_count_by_lane_km(km.id, lane)[0][:num]
        tmp << count
      end
      lanes.merge!({ lane => tmp })
    end
    lanes
  end

end
