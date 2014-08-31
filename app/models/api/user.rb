class Api::User < User

  scope :list, ->{ select('users.id, users.name, users.father_last_name, users.mother_last_name, users.mail') }
  scope :exclude, ->(id){ where.not(id: id) }

  # methods
  def auth_token
    @auth_token ||= Api::Token.auth_token(self.id)
  end
  
  def self.api_find_by_id(id, user)
    base = self.base
    self.filter(base, user).filter_by_id(id).first
  end
  
  def serialize
    @serialize ||= ->{
      token = self.auth_token
      unless token.nil?
        token.serialize
      end
    }.call
  end
  
  def self.filter(base, user)
    base.merge(self.exclude(user.id))
  end
  
  # Optimize to allow multiple kms for mobile app
  # One km is selected for user
  # returns km object
  def assigned_km
    @assigned_km ||= self.app_user_km
  end
  
  protected
  
  def app_user_km
    @user_km ||= Api::UserKm.app_user_km(self.id)
  end

end
