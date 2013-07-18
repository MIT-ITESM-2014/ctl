class Api::CitiesController < Api::ApiController
  
  include Api::Cityable
  
  before_filter :assert_post
  before_filter :assert_city, only: [:list_kms]
  
  # POST /api/cities/list
  def list
    Api::City.json_display = Api::City::Json::List
    render json: { contents: Api::City.list }
  end
  
  # POST /api/cities/list_kms
  def list_kms
    Api::Km.json_display = Api::Km::Json::Default
    render json: { contents: self.city.active_kms_filter }
  end
  
  
end