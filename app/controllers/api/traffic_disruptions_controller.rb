class Api::TrafficDisruptionsController < Api::ApiController
  
  include Api::Kmable
  
  before_filter :assert_km, only: [:chart, :map]
  before_filter :assert_kms, only: [:sources, :deliveries]
  
  # POST /api/traffic_disruptions/chart
  def chart
    Api::DeliveriesDisruption.json_display = Api::DeliveriesDisruption::Json::Chart
    render json: { contents: self.km.api_chart_disruptions }
  end
  
  # POST /api/traffic_disruptions/map
  def map
    Api::TrafficDisruption.json_display = Api::TrafficDisruption::Json::Map
    render json: { contents: self.km.api_map_disruptions }
  end
  
  # POST /api/traffic_disruptions/sources
  def sources
    render json: { contents: Api::Km.api_traffic_disruption_sources(@kms) }
  end
  
  # POST /api/traffic_disruptions/delivieries
  def deliveries
    render json: { contents: Api::TrafficDisruption.api_delivery_percentage(@kms) }
  end
  
end
