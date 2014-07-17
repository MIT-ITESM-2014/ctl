class KmsController < FrontController
  
  before_filter :assert_ajax_post, only: [:select]
  before_filter :assert_km, only: [:show, :show_action, :select]
  before_filter :assert_kms, only: [:compare, :stats]
  before_filter :page_elements, only: [:show]
  
  def show
    render layout: 'application'
  end
  
  def show_action
    self.set_display
  end
  
  def stats
    @title = 'Statistics Report'
    @description = 'Descripción'
    @tags = 'tags'
    @ids = self.get_kms_ids
    @names = self.get_kms_subtitle
    render layout: 'application'
  end
  
  def compare
    @title = 'Compare'
    @description = 'Descripción'
    @tags = 'tags'
    render layout: 'application'
  end
  
  def select
    self.get_location
  end
  
  def select_action
    
  end
  
  protected
  
  def assert_kms
    tmp = []
    kms = params[:km]
    self.set_show_display
    unless kms.nil? && kms.kind_of(Hash)
      kms.each do |k, id|
        val = self.get_api_km(id)
        render_404 if val.nil?
        tmp << val
      end
    end
    @kms = tmp unless tmp.empty?
  end
  
  def get_kms_ids
    @kms.map do |km|
      km.id
    end
  end
  
  def get_kms_subtitle
    names = @kms.map do |km|
      km.name
    end
    names.join('|')
  end
  
  def get_location
    @location = { km_id: @km.id, city_id: @km.city_id, country_id: @km.country_id }
  end
  
  def set_show_display
    Api::Km.json_display = Api::Km::Json::Show
  end
  
  def set_display
    Api::Km.json_display = Api::Km::Json::List
  end
  
  def set_stats
    Api::Km.json_display = Api::Km::Json::Stats
  end
  
  def title
    @title ||= self.get_title(@km.full_name)
  end
  
  def description
    @description ||= self.get_description(self.km.description)
  end
  
  def assert_km
    render_404 if self.km.nil?
  end
  
  def km
    @km ||= Api::Km.find_by_full_slug(params[:country], params[:city], params[:km])
  end
  
  def get_api_km(id)
    Api::Km.find_api_base_by_id(id)
  end
  
  def get_km(country, city, km)
    Api::Km.find_by_full_slug(country, city, km)
  end
  
end
