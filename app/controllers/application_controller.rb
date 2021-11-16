class ApplicationController < ActionController::Base
    before_action :redirect_empty_company_users
    
    def redirect_empty_company_users
        # Eu não sei por que, mas só ta funcionando assim, por mais que seja redundante
        # byebug
        if current_user && current_user.incomplete_company?
            redirect_to edit_company_path current_user.company
        end
    end
end
