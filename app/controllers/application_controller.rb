class ApplicationController < ActionController::Base
  def authenticate_users!
    return if user_signed_in? || admin_signed_in?

    redirect_to root_path, alert: 'Faça login para ter acesso ao sistema'
  end
end
