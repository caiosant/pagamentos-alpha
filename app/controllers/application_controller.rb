class ApplicationController < ActionController::Base
  def authenticate_users!
    return if user_signed_in? || admin_signed_in?

    redirect_to root_path, alert: 'Faça login para ter acesso ao sistema'
  end

  before_action :redirect_empty_company_users, unless: :devise_controller?

  def redirect_empty_company_users
    redirect_to edit_company_path current_user.company if current_user&.incomplete_company?
  end

  def authenticate_user_company_accepted
    authenticate_users!
    return if current_user.accepted_company?

    redirect_to company_path(current_user.company),
                alert: t('companies.not_accepted_alert')
  end

  def find_company_and_authenticate_owner
    find_company

    return if current_user&.owns?(@company)

    redirect_to root_path, alert: t('companies.edit.no_permission_alert')
  end

  def redirect_if_pending_company
    return unless @company.pending?

    redirect_to @company
  end

  def find_company
    @company = Company.find(params[:id])
  end

  def authenticate_company_user
    find_company

    return if current_user&.in_company?(@company)

    redirect_to root_path, alert: t('companies.show.no_permission_alert')
  end
end
