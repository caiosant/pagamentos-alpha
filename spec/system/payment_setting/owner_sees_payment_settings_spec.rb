require 'rails_helper'

describe 'Owner sees payment' do
  xit 'methods sucessfully' do
    payment1, payment2, payment3 = create_list(:payment_methods, 3)
    payment3.disabled!
    owner = create(:user, :complete_company_owner)
    owner.company.accepted!

    login_as owner, scope: :user
    visit company_path owner.company
    click_on 'Meios de pagamento configurados'

    expect(current_path).to eq(company_payment_settings_path owner.company)
    expect(page).to have_content('Criar nova configuração de pagamento:')
    expect(page).to have_link(payment1.name)
    expect(page).to have_link(payment2.name)
    expect(page).not_to have_content(payment3.name)
  end

  # TODO: testar com setting que não seja de owner.company
  it 'settings successfully' do
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

    login_as owner, scope: :user
    visit company_path company
    click_on 'Meios de pagamento configurados'

    expect(page).to have_content(pix_setting.pix_key)
    expect(page).to have_content(pix_setting.bank_code)
    expect(page).to have_content(credit_card_setting.company_code)
    expect(page).to have_content(boleto_setting.bank_code)
    expect(page).to have_content(boleto_setting.agency_number)
    expect(page).to have_content(boleto_setting.account_number)
  end

  it 'unless company is not approved'
end
