class Api::KmsController < Api::ApiController
  
  before_filter :assert_post, only: [:show]
  before_filter :assert_kms, only:[:lanes, :parking]
  
  # POST /api/kms/show
  def show
    Api::Km.json_display = Api::Km::Json::Show
    el = Api::Km.find_api_base_by_id(params[:km_id])
    if el.nil?
      render_404
    else
      render json: { km: el }
    end
  end
  
  def lanes
    render json: { contents: self.cls.api_lanes(@kms) }
  end
  
  def parking
    render json: { contents: self.cls.api_parking(@kms) }
  end
  
  protected
  
  def cls
    Api::Km
  end
  
  def assert_kms
    tmp = []
    kms = params[:km]
    #self.set_show_display
    unless kms.nil? && kms.kind_of?(Array)
      kms.each do |id|
        val = self.get_api_km(id)
        render_404 if val.nil?
        tmp << val
      end
    end
    @kms = tmp unless tmp.empty?
  end
 
  def get_api_km(id)
    Api::Km.find_by_id(id)
  end   

end
