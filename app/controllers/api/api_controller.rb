class Api::ApiController < ApplicationController

  attr_accessor :app_session

  layout false

  #TODO session and tokens
  protected

  def assert_user
    render_403 if self.app_session.nil?
  end

  def assert_protected
    render_401 if self.app_session.nil?
  end

  def app_session
    @app_session ||= ->{
      data = self.request.headers
      if data['Auth-Token'].present? && data['Auth-Secret'].present?
        token = Api::Token.find_auth_token(data['Auth-Token'], data['Auth-Secret'])
        unless token.nil?
          token.renew
          token.save
          token.user
        end
      end
    }.call
  end

end
