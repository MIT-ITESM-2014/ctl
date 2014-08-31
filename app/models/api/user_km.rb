class Api::UserKm < UserKm

  def self.app_user_km(user_id)
    self.base.filter_by_user(user_id).first
  end

  def app_km
    @app_km ||= Api::Km.app_find_by_id(self.km_id)
  end

end
