class CompaniesController < ApplicationController
  #TODO : AUTENTICAR USUARIO E QUE ELE É DONO DA COMPANY
  def edit
    @company = Company.find(params[:id])
  end

  def update
    @company = Company.find(params[:id])
  end
end