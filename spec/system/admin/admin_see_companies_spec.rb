require 'rails_helper'

describe 'Admin try to see all companies' do
    it 'sucessfully' do
        user1 = create(:user, :complete_company_owner)
        user2 = create(:user, :complete_company_owner)
        admin = create(:admin)

        login_as admin, scope: :admin
        visit root_path
        click_on 'Gerenciar Empresas'

        
        expect(page).to have_content('Owner')
        expect(page).to have_content('Empresa')
        expect(page).to have_content('Status')
        expect(page).to have_content('Ação')
        expect(page).to have_content(user1.email)
        expect(page).to have_content(user2.email)
        expect(page).to have_content(user1.company.legal_name)
        expect(page).to have_content(user2.company.legal_name)
        expect(page).to have_content(user1.company.legal_name)
        expect(page).to have_content(user2.company.legal_name)
    end
end