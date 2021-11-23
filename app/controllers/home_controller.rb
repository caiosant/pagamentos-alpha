class HomeController < ApplicationController
  def index
    redirect_to admin_dashboard_path if admin_signed_in?
  end
end
