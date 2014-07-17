class Api::TrafficCount < TrafficCount
  
  Top = 3
  
  module Field
    LBase = 'app.model.api.traffic_count.field'
    Cars = 0
    Taxis = 1
    PickupTrucks = 2
    ArticulatedTrucks = 3
    RigidTrucks = 4
    Vans = 5
    Buses = 6
    Bikes = 7
    MotorBikes = 8
    Pedestrians = 9
    List = {
      Cars => {
        name: I18n.t("#{LBase}.cars"),
        method: :cars,
        visible: true
      },
      Taxis => {
        name: I18n.t("#{LBase}.taxis"),
        method: :taxis,
        visible: true
      },
      PickupTrucks => {
        name: I18n.t("#{LBase}.pickup_trucks"),
        method: :pickup_trucks,
        visible: false
      },
      ArticulatedTrucks => {
        name: I18n.t("#{LBase}.articulated_trucks"),
        method: :articulated_trucks,
        visible: false
      },
      RigidTrucks => {
        name: I18n.t("#{LBase}.rigid_trucks"),
        method: :rigid_trucks,
        visible: false
      },
      Vans => {
        name: I18n.t("#{LBase}.vans"),
        method: :vans,
        visible: true
      },
      Buses => {
        name: I18n.t("#{LBase}.buses"),
        method: :buses,
        visible: true
      },
      Bikes => {
        name: I18n.t("#{LBase}.bikes"),
        method: :bikes,
        visible: true
      },
      MotorBikes => {
        name: I18n.t("#{LBase}.motorbikes"),
        method: :motorbikes,
        visible: true
      },
      Pedestrians => {
        name: I18n.t("#{LBase}.pedestrians"),
        method: :pedestrians,
        visible: true
      }
    }
    def self.keys
      @@keys ||= List.keys
    end
  end
  
  scope :api_vehicles_base, ->{ select('traffic_counts.cars, traffic_counts.taxis, traffic_counts.pickup_trucks, traffic_counts.articulated_trucks, traffic_counts.rigid_trucks, traffic_counts.vans, traffic_counts.buses, traffic_counts.bikes, traffic_counts.motorbikes, traffic_counts.pedestrians') }
  scope :api_km_vehicles, ->(km_id){ api_vehicles_base.filter_by_km(km_id) }
  
  def self.api_top_vehicle_usage_by_km(km_id)
    result = []
    tc = self.api_km_vehicles(km_id)
    Field::List.each do |key, field|
      sum = 0
      tc.each do |el|
        val = el.get_stats_by_method(field[:method])
        sum += val
      end
      result << { name: field[:name], total: sum }
    end
    result = result.sort_by do |el|
      el[:total]
    end
    result = result.last(Top).map do |el|
      el[:name]
    end
    result
  end
  
  def self.api_vehicle_usage(kms)
    result = { usage: [], kms: kms }
    Field::List.each do |key, field|
      tmp_data = []
      kms.each do |km|
        sum = 0
        tc = km.traffic_counts
        tc.each do |el|
          sum += el.get_stats_by_method(field[:method])
        end
        tmp_data << sum
      end
      result[:usage] << { name: field[:name], data: tmp_data, visible: field[:visible] }
    end
    Api::Km.json_display = Api::Km::Json::Obstruction 
    result
  end

end
