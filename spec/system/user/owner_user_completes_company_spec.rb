require 'rails_helper'

describe '(owner)User fills in company detail and sees aproval awaiting page' do
  it 'successfully' do
    user = create(:user, owner: :true)

    login_as user, scope: :user
    visit root_path

    fill_in 'company_legal_name', with: 'Empresa numero 1'
    fill_in 'company_billing_address', with: 'Endereço cidade tal rua tal etc'
    fill_in 'company_billing_email', with: 'faturamento@companymail.com'
    fill_in 'company_cnpj', with: '12.123.123/0001-12'
    click_on 'commit'

    expect(page).to have_content('Registro feito com sucesso!')
    expect(page).to have_content('pending')
  end

  it 'unless cnpj is invalid' do
    user = create(:user, owner: :true)

    login_as user, scope: :user
    visit root_path

    fill_in 'company_legal_name', with: 'Empresa numero 1'
    fill_in 'company_billing_address', with: 'Endereço cidade tal rua tal etc'
    fill_in 'company_billing_email', with: 'faturamento@companymail.com'
    fill_in 'company_cnpj', with: 'batatinha'
    click_on 'commit'

    expect(page).to have_content('Cnpj inválido')
  end

  it 'unless email domain is public' do
    user = create(:user, owner: :true)

    login_as user, scope: :user
    visit root_path

    fill_in 'company_legal_name', with: 'Empresa numero 1'
    fill_in 'company_billing_address', with: 'Endereço cidade tal rua tal etc'
    fill_in 'company_billing_email', with: 'faturamento@gmail.com'
    fill_in 'company_cnpj', with: '12.123.123/0001-12'
    click_on 'commit'

    expect(page).to have_content('Billing email não pode ser um email de domínio público')
  end

  it 'there are blank fields' do
    user = create(:user, owner: :true)

    login_as user, scope: :user
    visit root_path
    click_on 'commit'

    expect(page).to have_content('can\'t be blank', count: 4)
  end
end
