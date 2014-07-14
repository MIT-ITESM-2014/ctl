class Api::ShopsController < Api::ApiController
  
  include Api::Kmable
  
  before_filter :assert_km, only: [:chart, :map, :heat, :stats]
  before_filter :assert_kms, only: [:inventory]
  
  # POST /api/shops/chart
  def chart
    Api::ShopTotal.json_display = Api::ShopTotal::Json::Chart
    render json: { contents: self.km.api_chart_shop_totals }
  end
  
  # POST /api/shops/map
  def map
    Api::Shop.json_display = Api::Shop::Json::Map
    render json: { contents: self.km.api_map_shops }
  end
  
  # POST /api/shops/heat
  def heat
    Api::Shop.json_display = Api::Shop::Json::Heat
    render json: { contents: self.km.api_heat_shops }  
  end
  
  # POST /api/shops/inventory
  def inventory
    render json: { contents: Api::Km.api_shop_inventory(@kms) }
  end
  
end
