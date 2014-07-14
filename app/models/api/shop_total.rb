class Api::ShopTotal < ShopTotal
  
  module Json
    Default = {}
    Chart = {
      methods: [:s_type_name],
      only: [:shop_type, :total]
    }
  end
  
  module ShopType #TODO numbers
    LBase = 'app.model.api.shop_total.shop_type'
    Grocery = 0
    Convinience = 1 
    Clothing = 2
    FoodDrink = 3
    Other = 4
    List = {
      Grocery => {
        name: I18n.t("#{LBase}.grocery"),
        types: [Shop::ShopType::Grocery, Shop::ShopType::KioskGrocery]
      },
      Convinience => {
        name: I18n.t("#{LBase}.convinience"),
        types: [Shop::ShopType::Convinience, Shop::ShopType::KioskConvinience]     
      },
      Clothing => {
        name: I18n.t("#{LBase}.clothing"),
        types: [Shop::ShopType::Clothing, Shop::ShopType::KioskClothing]  
      },
      FoodDrink => {
        name: I18n.t("#{LBase}.food_drink"),
        types: [Shop::ShopType::Food, Shop::ShopType::KioskFood]  
      },
      Other => {
        name: I18n.t("#{LBase}.other"),
        types: [Shop::ShopType::Other, Shop::ShopType::KioskOther]  
      }
    }   
    def self.keys
      @@keys ||= List.keys
    end
  end
  
  scope :api_chart_base, ->{ select('shop_totals.shop_type, shop_totals.total').with_data }
  scope :api_stats_base, ->{ select('shop_totals.total') }
  
  def self.json_display
    @@json_display ||= Json::Default
  end
  
  def self.json_display=(val)
    @@json_display = val
  end
  
  def as_json(opts = {})
    super(opts.merge(self.class.json_display))
  end
  
  def self.stat_inventory(km_id, shop_type)
    self.api_stats_base.filter_by_shop_type(shop_type).filter_by_km(km_id).first
  end
  
  def self.api_stats_inventory_chart(km)
    id = km.id
    data = ShopType::List.map do |k, s_type|
      sum = 0
      s_type[:types].each do |el|
        sum += self.stat_inventory(id, el).total
      end
      [s_type[:name], sum]
    end
    result = {
      name: km.name,
      id: km.name.downcase,
      data: data
    }
    result
  end
  
  
end
