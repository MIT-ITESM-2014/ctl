class Api::UsersController < Api::ApiController

  # POST /api/users/login
  def login
    user = self.cls.authenticate(params[:mail], params[:password])
    token = nil
    unless user.nil?
      #self.app_session = user.serialize.to_json.html_safe
      token = user.serialize
    end
    render json: { token: token }
  end

  protected
  
  def cls
    @cls ||= Api::User
  end

end
