module Api::Kmable
  
  extend ActiveSupport::Concern
  
  included do
    
    def assert_km
      self.render_404 if self.km.nil?
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
    
    def km
      @km ||= Api::Km.find_active_by_id(params[:km_id])
    end
    
    def get_api_km(id)
      Api::Km.find_by_id(id)
    end
    
  end
  
end
