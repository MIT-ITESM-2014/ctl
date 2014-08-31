class Api::Token < Token

  def user
    @user ||= Api::User.find_by_id(self.user_id)
  end
  
  def self.auth_token(user_id)
    el = self.find_by_user(user_id, identity: Identity::Auth)
    if el.nil?
      el = self.api_generate(user_id, Identity::Auth) 
      el = nil unless el.save
    end
    el
  end
  
  # Longer expiry day advance
  # Returns current date plus 10 days
  # FIXME should not expire
  def self.api_expiry 
    Time.now.advance(days: 10)
  end
  
  def self.api_generate(user_id, identity)
    self.generate_token(user_id, { expires_at: self.api_expiry, identity: identity })
  end
  
  def self.find_auth_token(token, secret)
    self.find_token(token, secret, identity: Identity::Auth)
  end

end
