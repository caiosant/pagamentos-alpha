class ApplicationController < ActionController::Base
  before_action :redirect_empty_company_users

  def redirect_empty_company_users
    redirect_to edit_company_path current_user.company if current_user&.incomplete_company?
  end

  def find_company_and_authenticate_owner
    find_company

    return if current_user&.owns?(@company)

    redirect_to root_path,
                alert: 'Você não tem permissão para alterar os dados '\
                       'dessa empresa.'
  end

  def find_company
    @company = Company.find(params[:id])
  end

  def authenticate_company_user
    find_company

    return if current_user&.in_company?(@company)

    redirect_to root_path,
                alert: 'Você não tem permissão para ver os dados dessa empresa.'
  end
end
