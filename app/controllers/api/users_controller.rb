class Api::UsersController < Api::ApiController

  def login
    render json: { token: Token.all.first }
  end

  protected
  
  def cls
    @cls ||= Api::User
  end

end
