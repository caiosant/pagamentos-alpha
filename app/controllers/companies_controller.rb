class CompaniesController < ApplicationController
  skip_before_action :redirect_empty_company_users, only: %i[ edit update ] 

  #TODO : AUTENTICAR USUARIO E QUE ELE É DONO DA COMPANY
  def edit
    @company = Company.find(params[:id])
  end

  def update
    @company = Company.find(params[:id])
  end
end