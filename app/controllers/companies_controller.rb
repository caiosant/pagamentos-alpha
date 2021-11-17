class CompaniesController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :redirect_empty_company_users, only: %i[edit update]
  before_action :find_company_and_authenticate_owner, only: %i[edit update]
  before_action :authenticate_company_user, only: %i[show]

  def show; end

  def edit; end

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
