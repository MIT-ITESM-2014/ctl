class Api::DeliveriesController < Api::ApiController
  
  include Api::Kmable
  
  before_filter :assert_km, only: [:chart, :map]
  before_filter :assert_kms, only: [:intensity, :peak, :duration]
  
  # POST /api/deliveries/chart
  def chart
    Api::DeliveryTotal.json_display = Api::DeliveryTotal::Json::Chart
    render json: { contents: self.km.api_chart_deliveries }
  end
  
  # POST /api/deliveries/map
  def map
    Api::Delivery.json_display = Api::Delivery::Json::Map
    render json: { contents: self.km.api_map_deliveries }
  end
  
  # POST /api/deliveries/intensity
  def intensity
    render json: { contents: Api::DeliveryTotal.delivery_intensity(@kms) }
  end
  
  # POST /api/deliveries/peak
  def peak
    render json: { contents: Api::DeliveryTotal.peak_period_average(@kms) }
  end
  
  # POST /api/deliveries/duration
  def duration
    render json: { contents: Api::Delivery.duration_quartiles(@kms) }
  end
  
end
