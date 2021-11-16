class CompaniesController < ApplicationController
  before_action :authenticate_user!, only: %i[edit update]
  skip_before_action :redirect_empty_company_users, only: %i[ edit update ] 
  before_action :get_company_and_authenticate_owner, only: %i[ edit update ]

  def edit
  end

  def update
  end
end
