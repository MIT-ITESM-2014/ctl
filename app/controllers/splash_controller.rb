class SplashController < FrontController
  
  before_filter :assert_ajax_post, only: [:km_select]
  before_filter :page_elements, only: [:index, :test]
  before_filter :assert_country, only: [:km_select]
  before_filter :assert_city, only: [:km_select]
  
  def index
    render layout: 'application'
  end
  
  def test
    render_404
    #render layout: 'application'
  end
  
  def km_select
     
  end
  
  protected
  
  def assert_country
    @country ||= Api::Country.find_by_id(params[:country_id])
    render_404 if @country.nil?
  end
  
  def assert_city
    @city ||= Api::City.find_active_by_id_and_country(params[:city_id], @country.id)
  end
  
end
