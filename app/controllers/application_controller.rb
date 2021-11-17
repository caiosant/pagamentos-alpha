class ApplicationController < ActionController::Base
    before_action :redirect_empty_company_users

    def redirect_empty_company_users
        if current_user && current_user.incomplete_company?
            redirect_to edit_company_path current_user.company
        end
    end

    def get_company_and_authenticate_owner
      get_company

      redirect_to root_path,
      alert: 'Você não tem permissão para alterar os dados '\
      'dessa empresa.' unless current_user && current_user.is_owner?(@company)
    end

    def get_company
        @company = Company.find(params[:id])
    end

    def authenticate_company_user
      get_company

      redirect_to root_path,
      alert: 'Você não tem permissão para ver os dados dessa empresa.' unless
      current_user && current_user.is_in_company?(@company)
    end
end
