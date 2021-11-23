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
    expect(page).to have_content(user1.email)
    expect(page).to have_content(user2.email)
    expect(page).to have_content(user1.company.legal_name)
    expect(page).to have_content(user2.company.legal_name)
    expect(page).to have_content(Company.human_attribute_name("status.#{user1.company.status}").capitalize)
    expect(page).to have_content(Company.human_attribute_name("status.#{user2.company.status}").capitalize)
  end

  it 'and hasnt did the login' do
    visit companies_path

    expect(current_path).to eq root_path
  end

  it 'and see only pending companies' do
    user1 = create(:user, :complete_company_owner)
    user2 = create(:user, :complete_company_owner)
    admin = create(:admin)

    login_as admin, scope: :admin
    visit root_path
    click_on 'Gerenciar Empresas'
    click_on 'Empresas Pendentes'

    expect(page).to have_content('Owner')
    expect(page).to have_content('Empresa')
    expect(page).to have_content('Status')
    expect(page).to have_content('Ação')
    expect(page).to have_content(user1.email)
    expect(page).to have_content(user2.email)
    expect(page).to have_content(user1.company.legal_name)
    expect(page).to have_content(user2.company.legal_name)
    expect(page).to have_content(Company.human_attribute_name("status.#{user1.company.status}").capitalize)
    expect(page).to have_content(Company.human_attribute_name("status.#{user2.company.status}").capitalize)
    expect(page).to have_link('Aprovar', count: 2)
    expect(page).to have_link('Rejeitar', count: 2)
  end

  context 'and try to accept a company' do
    it 'sucessfully' do
      user1 = create(:user, :complete_company_owner)
      admin = create(:admin)

      login_as admin, scope: :admin
      visit root_path
      click_on 'Gerenciar Empresas'
      click_on 'Empresas Pendentes'
      click_on 'Aprovar'

      expect(page).to have_content('Owner')
      expect(page).to have_content('Empresa')
      expect(page).to have_content('Status')
      expect(page).to have_content(user1.email)
      expect(page).to have_content(user1.company.legal_name)
      expect(page).to have_content('Aprovada')
    end
  end
end
