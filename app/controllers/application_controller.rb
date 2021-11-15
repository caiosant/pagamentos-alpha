class ApplicationController < ActionController::Base
    def redirect_empty_company_users
        # Eu não sei por que, mas só ta funcionando assim, por mais que seja redundante
        if current_user
            if current_user.company and current_user.company.empty?
                redirect_to edit_company_path current_user.company
            end
        end
    end
end
