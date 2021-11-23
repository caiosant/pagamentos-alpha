require 'rails_helper'

describe 'Owner creates subscription' do
  it 'successfully' do
    owner = create(:user, :complete_company_owner)
    owner.company.accepted!

    login_as owner, scope: :user
    visit company_path owner.company
    click_on 'Registrar nova assinatura'

    fill_in 'Nome', with: 'assinatura do melhor video'
    click_on 'Criar Assinatura'

    expect(page).to have_content('Assinatura criada com sucesso')
    expect(page).to have_content('assinatura do melhor video')
    expect(page).to have_content('Estado: Habilitado')
    expect(Subscription.last.token.length).to eq(20)
    expect(page).to have_content("Token de integração: #{Subscription.last.token}")
  end

  it 'but cant see register if not approved' do
    owner = create(:user, :complete_company_owner)

    login_as owner, scope: :user
    visit company_path owner.company
    expect(page).to_not have_link('Registrar nova assinatura')
  end
  
end
