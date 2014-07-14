class Api::StreetsController < Api::ApiController
  
  include Api::Kmable
  
  before_filter :assert_km, only: [:chart, :map]
  before_filter :assert_kms, only: [:distribution]
  
  # POST /api/streets/chart
  def chart
    Api::Street.json_display = Api::Street::Json::Chart
    render json: { contents: self.km.api_chart_streets }
  end
  
  # POST /api/streets/map
  def map
    render json: { contents: self.km.api_map_streets }
  end
  
  def distribution
    render json: { contents: Api::StreetData.api_lanes_bays_distribution(@kms) }
  end
  
end
