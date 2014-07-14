class Api::TrafficCount < TrafficCount

  module Field
    LBase = 'app.models.api.traffic_count.field'
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
        name: I18n.("#{LBase}.cars"),
        method: :cars,
        visible: true
      },
      Taxis => {
        name: I18n.("#{LBase}.taxis"),
        method: :taxis,
        visible: true
      },
      PickupTruck => {
        name: I18n.("#{LBase}.pickup_trucks"),
        method: :pickup_trucks,
        visible: false
      },
      ArticulatedTrucks => {
        name: I18n.("#{LBase}.articulated_trucks"),
        method: :articulated_trucks,
        visible: false
      },
      RigidTrucks => {
        name: I18n.("#{LBase}.rigid_trucks"),
        method: :rigid_trucks,
        visible: false
      },
      Vans => {
        name: I18n.("#{LBase}.vans"),
        method: :vans,
        visible: true
      },
      Buses => {
        name: I18n.("#{LBase}.buses"),
        method: :cars,
        visible: true
      },
      Bikes => {
        name: I18n.("#{LBase}.bikes"),
        method: :bikes,
        visible: true
      },
      MotorBikes => {
        name: I18n.("#{LBase}.motorbikes"),
        method: :motorbikes,
        visible: true
      },
      Pedestrians => {
        name: I18n.("#{LBase}.pedestrians"),
        method: :pedestrians,
        visible: true
      }
    }
    def self.keys
      @@keys ||= List.keys
    end
  end
  
  def self.api_vehicle_usage(kms)
    
  end

end
