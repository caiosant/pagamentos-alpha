class HomeController < ApplicationController
  before_action :redirect_empty_company_users, only: [:index]
  def index
  end
end
