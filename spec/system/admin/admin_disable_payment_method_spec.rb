require 'rails_helper'

describe 'administrator disable a payment method' do
  it 'must be signed in' do
    visit new_payment_method_path

    expect(page).to have_content('Faça login para ter acesso ao sistema')
  end

  it 'successfully' do
    admin = create(:admin)
    payment_method = create(:payment_method)
    login_as admin, scope: :admin
    visit root_path

    click_on 'Listar métodos de pagamentos'
    click_on payment_method.name
    click_on 'Desabilitar método de pagamento'

    expect(page).to have_content('Nome: Cartão de Crédito Visa')
    expect(page).to have_content('Taxa (%): 5.0')
    expect(page).to have_content('Taxa máxima (R$): 50.0')
    expect(page).to have_content('Status: Desabilitado')
    expect(page).to have_link('Habilitar método de pagamento')
  end
end
