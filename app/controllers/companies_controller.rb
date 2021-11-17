class CompaniesController < ApplicationController
  before_action :authenticate_user!, only: %i[edit update]
  skip_before_action :redirect_empty_company_users, only: %i[ edit update ] 
  before_action :get_company_and_authenticate_owner, only: %i[ edit update ]

  # TODO: teste(request) de autenticacao nesse metodo
  def show
    get_company
  end

  def edit
  end

  def update
    if @company.update(edit_company_params)
      redirect_to @company, notice: 'Registro feito com sucesso!'
    else
      render :edit
    end
  end

  private

  def edit_company_params
    params.require(:company).permit(
      :legal_name,
      :cnpj,
      :billing_email,
      :billing_address
    )
  end
end
