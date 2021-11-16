class ApplicationController < ActionController::Base
    before_action :redirect_empty_company_users
    
    def redirect_empty_company_users
        # Eu não sei por que, mas só ta funcionando assim, por mais que seja redundante
        # byebug
        if current_user && current_user.incomplete_company?
            redirect_to edit_company_path current_user.company
        end
    end

    def get_company_and_authenticate_owner
      @company = Company.find(params[:id])

      redirect_to root_path,
      alert: 'Você não tem permissão para alterar os dados '\
      'dessa empresa.' unless
             @company == current_user.company && current_user.owner
    end
end
