class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  helper_method :current_user

  def current_user
   @current_user ||= User.find(session[:user_id]) if session[:user_id]
 end

 def reset_token
   @reset_token ||= SecureRandom.uuid
 end
end
