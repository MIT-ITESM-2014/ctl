class Api::Block < Block

  scope :app_base, ->{ select('blocks.id, blocks.km_id, blocks.research_id') }
  
  def self.app_find_by_km(km_id)
    self.app_base.filter_by_id(km_id)
  end

end
