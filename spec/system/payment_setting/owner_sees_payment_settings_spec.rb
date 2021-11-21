require 'rails_helper'

describe 'Owner sees payment settings' do

  # TODO: testar com setting que não seja de owner.company
  it 'successfully' do
    owner = create(:user, :complete_company_owner)
    company = owner.company
    company.accepted!

    credit_card_method = create(:payment_method, :credit_card)
    pix_method = create(:payment_method, :pix)
    boleto_method = create(:payment_method, :boleto)

    credit_card_setting = create(
      :credit_card_setting, company:company, payment_method: credit_card_method
    )
    pix_setting = create(
      :pix_setting, company:company, payment_method: pix_method
    )
    boleto_setting = create(
      :boleto_setting, company:company, payment_method: boleto_method
    )
    boleto_setting2 = create(
      :boleto_setting, company:company, payment_method: boleto_method
    )

    login_as owner, scope: :user
    visit company_path company
    click_on 'Meios de pagamento configurados'

    expect(page).to have_content('Configurar novo pix')
    expect(page).to have_content('Configurar novo boleto')
    expect(page).to have_content('Configurar novo cartão de crédito')

    expect(page).to have_content("Chave PIX: #{pix_setting.pix_key}")
    expect(page).to have_content("Código do banco: #{pix_setting.bank_code}")
    expect(page).to have_content("Código do cartão: #{credit_card_setting.company_code}")
    expect(page).to have_content("Código do banco: #{boleto_setting.bank_code}")
    expect(page).to have_content("Número da agência: #{boleto_setting.agency_number}")
    expect(page).to have_content("Número da agência: #{boleto_setting.account_number}")
  end

  it 'pix creation form successfully' do
    pix_method, pix_method2, pix_method3  = create_list(:payment_method, 3, :pix)
    pix_method3.disabled!

    owner = create(:user, :complete_company_owner)
    owner.company.accepted!

    login_as owner, scope: :user
    visit company_path owner.company
    click_on 'Meios de pagamento configurados'
    click_on 'Configurar novo pix'

    expect(current_path).to eq(new_pix_setting)
    expect(page).to have_content('Digite as informações abaixo para registrar um novo pagamento PIX:')
    expect(page).to have_content('Chave PIX')
    expect(page).to have_content('Código do banco')
    expect(page).to have_content('Meio de pagamento')
    expect(page).to_not have_content(pix_method3.name)
    expect(page).to have_content(pix_method)
    expect(page).to have_content(pix_method2)
    
  end

  it 'credit card creation form successfully'
  it 'boleto creation form successfully'

  it 'unless company is not approved'
end
