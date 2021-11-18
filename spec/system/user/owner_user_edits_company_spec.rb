require 'rails_helper'

describe 'Owner edits accepted company' do
  it 'successfully' do
    owner = create(:user, :complete_company_owner)
    owner.company.accepted!

    login_as owner, scope: :user
    visit company_path(owner.company)
    click_on 'Editar dados'

    fill_in 'Razão social', with: 'Empresa numero 2'
    fill_in 'Endereço de faturamento', with: 'Endereço cidade tal rua tal etc'
    fill_in 'E-mail de faturamento', with: 'faturamento@companymail.com'
    fill_in 'CNPJ', with: '12.123.123/0001-12'
    click_on 'Enviar'

    expect(current_path).to eq(company_path(owner.company))
    expect(page).to have_content('Razão social: Empresa numero 2')
    expect(page).to have_content('Endereço de faturamento: Endereço cidade tal rua tal etc')
    expect(page).to have_content('E-mail de faturamento: faturamento@companymail.com')
    expect(page).to have_content('CNPJ: 12.123.123/0001-12')
  end

  it 'and user from company cannot view edit link' do
    owner = create(:user, :complete_company_owner)
    owner.company.accepted!
    user = create(:user, owner: false, company: owner.company)

    login_as user, scope: :user
    visit company_path(owner.company)

    expect(page).not_to have_link('Editar dados', href: edit_company_path(owner.company))
  end
end
