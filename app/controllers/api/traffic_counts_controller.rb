class Api::TrafficCountsController < Api::ApiController
  
  include Api::Kmable
  
  before_filter :assert_km, only: [:chart]
  before_filter :assert_kms, only: [:vehicles]
  
  # POST /api/traffic_counts/chart
  def chart
    render json: { contents: self.km.api_chart_traffic_count_totals }
  end
  
  # POST /api/traffic_counts/vehicles
  def vehicles
    render json: { contents: Api::TrafficCount.api_vehicle_usage(@kms) }
  end
  
end
