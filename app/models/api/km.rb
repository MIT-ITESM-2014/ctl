class Api::Km < Km
  
  WeekHours = 40
  
  module Json
    Default = {}
    List = {
      only: [:id],
      methods: [:full_slug]
    }
    Show = {
      only: [:id, :name, :description, :shops_count, :public_meter_length, :dedicated_meter_length, :peak_deliveries, :peak_disruptions, :peak_traffic, :max_deliveries, :lat, :lng, :street_lat, :street_lng, :ucf, :uff, :speed],
      methods: [:full_name, :full_slug, :utc_offset, :s_peak_delivery_hour, :disruption_average]
    }
    Stats = {
      only: [:id, :name, :description, :shops_count, :public_meter_length, :dedicated_meter_length, :peak_deliveries, :peak_disruptions, :peak_traffic, :max_deliveries, :lat, :lng, :street_lat, :street_lng, :ucf, :uff, :speed, :area_type],
      methods: [:full_name, :full_slug, :utc_offset]
    }
    Obstruction = {
      only: [:id, :name]
    }
  end
  
  module Categories
    LBase = 'app.model.api.km.categories'
    General = 0
    Shops = 1
    Traffic = 2
    RoadsAndRegulations = 3
    DisruptiveViolations = 4
    DeliveryTracking = 5
    module Fields
      # General
      Country = 0
      City = 1
      AreaType = 2
      # Shops
      ShopInventory = 0
      TopShopTypes = 1
      # Traffic
      Speed = 0
      TrafficCount = 1
      TopVehicleType = 2
      # Roads
      UCF = 0
      UFF = 1
      PublicBays = 2
      PrivateBays = 3
      OneWayStreets = 4
      TwoWayStreets = 5
      # Disruption
      DisruptionPeakWeek = 0
      DisruptionPeakHour = 1
      DisruptionAverage = 2
      TopDisruptionType = 3
      # Delivery
      DeliveryPeekWeek = 0
      DeliveryPeakHour = 1
      DeliveryAverage = 2
      DeliveryAverageDuration = 3
      DeliveryEquipmentPercentage = 4 # Eliminated
      DeliveryNoEquipmentPercentage = 5 # Eliminated
      TopDeliveryType = 6
    end
    List = {
      General => {
        name: I18n.t("#{LBase}.general"),
        fields: {
          Fields::Country => {
            name: I18n.t("#{LBase}.fields.country"),
            method: :country_name
          },
          Fields::City => {
            name: I18n.t("#{LBase}.fields.city"),
            method: :city_name
          },
          Fields::AreaType => {
            name: I18n.t("#{LBase}.fields.area_type"),
            method: :area_type
          }
        }
      },
      Shops => {
        name: I18n.t("#{LBase}.shops"),
        fields: {
          Fields::ShopInventory => {
            name: I18n.t("#{LBase}.fields.shop_inventory"),
            method: :shops_count
          },
          Fields::TopShopTypes => {
            name: I18n.t("#{LBase}.fields.top_shop_types"),
            method: :top_shop_types
          }
        }
      },
      Traffic => {
        name: I18n.t("#{LBase}.traffic"),
        fields: {
          Fields::Speed => {
            name: I18n.t("#{LBase}.fields.speed"),
            method: :speed
          },
          Fields::TrafficCount => {
            name: I18n.t("#{LBase}.fields.traffic_count"),
            method: :traffic_counts_count
          },
          Fields::TopVehicleType => {
            name: I18n.t("#{LBase}.fields.top_vehicle_type"),
            method: :top_vehicle_types
          }
        }
      },
      RoadsAndRegulations => {
        name: I18n.t("#{LBase}.roads_and_regulations"),
        fields: {
          Fields::UCF => {
            name: I18n.t("#{LBase}.fields.ucf"),
            method: :ucf
          },
          Fields::UFF => {
            name: I18n.t("#{LBase}.fields.uff"),
            method: :uff
          },
          Fields::PublicBays => {
            name: I18n.t("#{LBase}.fields.public_bays"),
            method: :public_meter_length
          },
          Fields::PrivateBays => {
            name: I18n.t("#{LBase}.fields.private_bays"),
            method: :dedicated_meter_length
          },
          Fields::OneWayStreets => {
            name: I18n.t("#{LBase}.fields.one_way_streets"),
            method: :one_way_streets
          },
          Fields::TwoWayStreets => {
            name: I18n.t("#{LBase}.fields.two_way_streets"),
            method: :two_way_streets
          }
        }
      },
      DisruptiveViolations => {
        name: I18n.t("#{LBase}.disruptive_violations"),
        fields: {
          Fields::DisruptionPeakWeek => {
            name: I18n.t("#{LBase}.fields.disruptions_peak_week"),
            method: :peak_disruptions
          },
          Fields::DisruptionPeakHour => {
            name: I18n.t("#{LBase}.fields.disruptions_peak_hour"),
            method: :s_peak_disruption_hour
          },
          Fields::DisruptionAverage => {
            name: I18n.t("#{LBase}.fields.disruption_average"),
            method: :disruption_average
          },
          Fields::TopDisruptionType => {
            name: I18n.t("#{LBase}.fields.top_disruption_type"),
            method: :top_disruption_type
          }
        }
      },
      DeliveryTracking => {
        name: I18n.t("#{LBase}.delivery_tracking"),
        fields: {
          Fields::DeliveryPeekWeek => {
            name: I18n.t("#{LBase}.fields.delivery_peak_week"),
            method: :peak_deliveries            
          },
          Fields::DeliveryPeakHour => {
            name: I18n.t("#{LBase}.fields.deliveries_peak_hour"),
            method: :peak_deliveries
          },
          Fields::DeliveryAverage => {
            name: I18n.t("#{LBase}.fields.delivery_hour"),
            method: :s_peak_delivery_hour
          },
          Fields::DeliveryAverageDuration => {
            name: I18n.t("#{LBase}.fields.delivery_average_duration"),
            method: :delivery_average_duration
          },
          Fields::TopDeliveryType => {
            name: I18n.t("#{LBase}.fields.top_delivery_type"),
            method: :top_delivery_type
          }
        }
      }
    }
    def self.keys
      @@keys ||= List.keys
    end
  end
  
  scope :filter_base, ->{ select('kms.id, kms.name') }
  scope :filter_by_country_slug, ->(slug){ where('countries.slug = ?', slug) }
  scope :filter_by_city_slug, ->(slug){ where('cities.slug = ?', slug) }
  scope :api_base, ->{ select('kms.id, kms.slug, kms.city_id, kms.name, kms.description, kms.traffic_counts_count, kms.shops_count, kms.public_meter_length, kms.dedicated_meter_length, kms.peak_deliveries, kms.peak_disruptions, kms.peak_disruption_hour, kms.peak_delivery_hour, kms.peak_traffic, kms.max_deliveries, kms.lat, kms.lng, kms.street_lat, kms.street_lng, kms.speed, kms.uff, kms.ucf, kms.area_type, kms.one_way_streets, kms.two_way_streets').with_city.with_city_slug.with_country }
  scope :list_base, ->{ select('kms.id, kms.slug, kms.name, kms.description').with_city.with_city_slug.with_country }
  scope :with_city_slug, ->{ select('cities.slug as city_slug, kms.city_id') }
  scope :with_city, ->{ select('cities.name as city_name').joins('JOIN cities ON cities.id = kms.city_id') }
  scope :with_country, ->{ select('countries.name as country_name, countries.id as country_id, countries.slug as country_slug').joins("JOIN countries ON countries.id = cities.country_id") }
  
  def self.json_display
    @@json_display ||= Json::Default
  end
  
  def self.json_display=(val)
    @@json_display = val
  end
  
  def full_slug
    @full_slug ||= "#{self[:country_slug]}/#{self[:city_slug]}/#{self.slug}"
  end
  
  def as_json(opts = {})
    super(opts.merge(self.class.json_display))
  end

  def self.find_api_base_by_city(id)
    self.api_base.filter_active.filter_by_city(id)
  end
  
  def self.find_api_base_by_id(id)
    self.api_base.filter_active.filter_by_id(id).first
  end
  
  def self.find_active_by_id(id)
    self.base.filter_active.filter_by_id(id).first
  end
  
  def self.find_by_full_slug(country_slug, city_slug, slug)
    self.list_base.filter_by_country_slug(country_slug).filter_by_city_slug(city_slug).filter_by_slug(slug).first
  end
  
  def top_delivery_type
    map = Api::Delivery.api_top_vehicles(self.id).map do |el|
      el.vehicle_type
    end
    map.join(', ')
  end
  
  def top_shop_types
    map = Api::Shop.api_top_shop_types(self.id).map do |el|
      Api::Shop::ShopType::List[el.shop_type][:name]
    end
    map.join(', ')
  end
  
  def api_chart_shop_totals
    @api_chart_shop_totals ||= Api::ShopTotal.api_chart_base.filter_by_km(self.id)
  end
  
  def api_map_shops
    @api_map_shops ||= ->{
      list = {}
      Shop::ShopType::List.each do |key, s_type|
        shop_total = Api::ShopTotal.find_by_km_shop_type(self.id, key)
        unless shop_total.nil? || shop_total.total.to_i <= 0
          el = {
            name: s_type[:name],
            elements: Api::Shop.map_data(self.id, key)
          }
          list[key] = el
        end
      end
      list
    }.call
  end
  
  def api_heat_shops
    @api_heat_shops ||= Api::Shop.heat_data(self.id)
  end
  
  def api_chart_streets
    @api_chart_streets ||= Api::Street.api_chart_base.filter_by_km(self.id)
  end
  
  def api_map_streets
    @api_map_streets ||= Api::Street.map_data(self.id)
  end
  
  def api_chart_deliveries
    @api_chart_deliveries ||= Api::DeliveryTotal.api_chart_base.filter_by_km(self.id)
  end
  
  def api_map_deliveries
    @api_map_deliveries ||= ->{
      list = {}
      Delivery::DeliveryType::List.each do |key, d_type|
        elements = Api::Delivery.map_data(self.id, key)
        if elements.length > 0
          el = {
            name: d_type[:name],
            elements: elements
          }
          list[key] = el
        end
      end
      list
    }.call
  end
  
  def api_chart_traffic_count_totals
    @api_chart_traffic_count_totals ||= ->{
      el = Api::TrafficCountTotal.find_chart_base_by_km(self.id)
      el.as_chart unless el.nil?
    }.call
  end
  
  def api_chart_disruptions
    @api_chart_disruptions ||= Api::DeliveriesDisruption.api_chart_base.filter_by_km(self.id)
  end
  
  def api_map_disruptions
    @api_map_disruptions ||= ->{
      list = {}
      TrafficDisruption::LengthType::List.each do |key, l_type|
        elements = Api::TrafficDisruption.map_data(self.id, key)
        if elements.length > 0
          el = {
            name: l_type[:name],
            elements: elements
          }
          list[key] = el
        end
      end
      list
    }.call
  end
  
  # Stats View
  def get_stat(method_sym)
    result = '-'
    if method_sym.kind_of?(Symbol) && self.respond_to?(method_sym)
      result = self.send(method_sym)
    end
    result
  end
  
  def s_peak_delivery_hour
    @s_peak_delivery_hour ||= ->{
      #t = Time.parse(self.peak_delivery_hour)
      t = self.peak_delivery_hour
      t.strftime "%H:%M"
    }.call
  end
 
  def s_peak_disruption_hour
    @s_peak_disruption_hour ||= ->{
      #t = Time.parse(self.peak_delivery_hour)
      t = self.peak_disruption_hour
      t.strftime "%H:%M"
    }.call
  end
  
  def delivery_average_duration
    @delivery_average_duration ||= ->{
      deliveries = Api::Delivery.api_duration_by_km(self.id)
      delivery_count = Api::Delivery.api_count_by_km(self.id)[0][:num]
      sum = 0
      deliveries.each do |el|
        minutes = el.delivery_duration
        minutes = minutes / 60
        sum += minutes
      end
      unless delivery_count == 0
        result = sum / delivery_count
      else
        result = 0
      end
      "#{result} min"
    }.call
  end
  
  def disruption_average
    @disruption_average ||= ->{
      disruptions = Api::TrafficDisruption.count_by_km(self.id)[0][:num]
      disruptions / WeekHours
    }.call
  end
  
  def top_vehicle_types
    @top_vehicle_types ||= ->{
      totals = Api::TrafficCount.api_top_vehicle_usage_by_km(self.id)
      totals.join(', ')
    }.call
  end
  
  def top_disruption_type
    @top_disruption_type ||= ->{
      map = Api::TrafficDisruption.api_top_sources(self.id).map do |disruption|
        Api::TrafficDisruption::Source::List[disruption.source][:name]
      end
      map.join(', ')
    }.call
  end
  
  def self.api_shop_inventory(kms)
    result = { series: [], drilldown: [] }
    Api::ShopTotal.json_display = Api::ShopTotal::Json::Chart
    kms.each do |km|
      result[:series] << {
        name: km.name,
        y: km.shops_count,
        drilldown: "#{km.name.downcase}_#{km.id}"
      }
      result[:drilldown] << Api::ShopTotal.api_stats_inventory_chart(km)
    end
    result
  end
  
  def self.api_traffic_disruption_sources(kms)
    result = []
    Api::TrafficDisruption::Source::List.each do |key, el|
      tmp = {
        name: el[:name],
        visible: el[:visible],
        data: Api::TrafficDisruption.api_source_for_kms(kms, key)
      }
      result << tmp
    end
    result
    Api::Km.json_display = Api::Km::Json::Obstruction
    { chart: result, kms: kms }
  end
  
  def self.api_lanes(kms)
    result = { one_way: [], two_way: [], kms: kms }
    kms.each do |km|
      result[:one_way] << km.one_way_streets
      result[:two_way] << km.two_way_streets
    end
    result
  end
  
  def self.api_parking(kms)
    result = { meters: {}, bays: {}, kms: kms }
    result[:meters] = self.api_parking_lengths(kms)
    result[:bays] = Api::Street.api_bays_distribution(kms)
    Api::Km.json_display = Api::Km::Json::Obstruction   
    result
  end
  
  def self.api_deliveries(kms)
    result = { series: [], drilldown: [] }
    kms.each do |km|
      result[:series] << {
        name: km.name,
        y: km.deliveries_count,
        drilldown: "#{km.name.downcase}_#{km.id}"
      }
      result[:drilldown] << Api::Delivery.api_top_vehicles_stats(km)
    end
    Api::Km.json_display = Api::Km::Json::Obstruction
    result
  end
  
  protected
  
  def self.api_parking_lengths(kms)
    lengths = { public_length: [], dedicated_length: [] }
    kms.each do |km|
      lengths[:public_length] << km.public_meter_length
      lengths[:dedicated_length] << km.dedicated_meter_length
    end
    lengths
  end
  
end
