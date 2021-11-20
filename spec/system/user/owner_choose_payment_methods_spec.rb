require 'rails_helper'

describe 'Owner choose payment method' do
  it 'and see only enabled payment methods' do
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
  it 'and sees configured methods' do
    owner = create(:user, :complete_company_owner)
    company = owner.company
    company.accepted!

    payment1 = create(:payment_method, type_of: :credit_card)
    payment2 = create(:payment_method, type_of: :pix)
    payment3 = create(:payment_method, type_of: :boleto)

    credit_card_setting = create(
      :credit_card_setting, company:company, payment_method: payment1
    )
    pix_setting = create(
      :pix_setting, company:company, payment_method: payment2
    )
    boleto_setting = create(
      :boleto_setting, company:company, payment_method: payment3
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

  it 'as credit card successfully' do
    credit_card_method = create(:payment_method)
    owner = create(:user, :complete_company_owner)
    owner.company.accepted!

    login_as owner, scope: :user
    visit company_path owner.company
    click_on 'Meios de pagamento configurados'
    click_on credit_card_method.name

    fill_in 'Código da conta', with: 'Yke0hLtqZKPVurU2eAEr'
    click_on 'Cadastrar metódo de pagamento'

    expect(current_path).to eq(company_path owner.company)
    expect(page).to have_content('Seus metódos de pagamento:')
    expect(page).to have_content(credit_card.name)
    expect(owner.company.payment_methods.first).to eq(credit_card_method)
  end

  it 'and can configure more than one method'

  it 'as pix successfully'

  it 'as boleto successfully'

  it 'and must be company owner'

  it 'cannot choose if company is not approved'

  it 'cannot choose same method twice'

  it 'edit configured method'
end
