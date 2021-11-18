class CompaniesController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :redirect_empty_company_users, only: %i[edit update]
  before_action :find_company_and_authenticate_owner, only: %i[edit update cancel_registration]
  before_action :redirect_if_pending_company, only: %i[edit update]
  before_action :authenticate_company_user, only: %i[show]

  def show; end

  def edit; end

  def update
    if @company.update(edit_company_params)
      @company.pending! if @company.rejected?
      redirect_to @company, notice: t('.complete_success_notice')
    else
      render :edit
    end
  end

  def cancel_registration
    @company.blank_all_info!

    redirect_to root_path
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
