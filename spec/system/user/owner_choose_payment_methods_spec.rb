require 'rails_helper'

describe 'Owner choose payment method' do
  it 'and see only enabled payment methods' do
    payment1, payment2, payment3 = create_list(:payment_methods, 3)
    payment3.disabled!
    owner = create(:user, :complete_company_owner)
    owner.company.accepted!

    login_as owner, scope: :user
    visit company_path owner.company
    click_on 'Configurar meios de pagamento'

    expect(current_path).to eq(payment_methods_path)
    expect(page).to have_content('Selecione os meios de pagamento da sua empresa:')
    expect(page).to have_link("#{payment1.name}")
    expect(page).to have_link("#{payment2.name}")
    expect(page).not_to have_content("#{payment3.name}")
  end

  it 'credit card successfully' do
    credit_card_method = create(:payment_method)
    owner = create(:user, :complete_company_owner)
    owner.company.accepted!

    login_as owner, scope: :user
    visit company_path owner.company
    click_on 'Configurar meios de pagamento'
    click_on credit_card_method.name

    fill_in 'Código da conta', with: 'Yke0hLtqZKPVurU2eAEr'
    click_on 'Cadastrar metódo de pagamento'

    expect(current_path).to eq(company_path owner.company)
    expect(page).to have_content('Seus metódos de pagamento:')
    expect(page).to have_content(credit_card.name)
    expect(owner.company.payment_methods.first).to eq(credit_card_method)
  end

  it 'pix successfully'

  it 'boleto successfully'

  it 'and must be company owner'

  it 'cannot choose if company is not approved'

  it 'cannot choose same method twice'

  it 'edit configured method'
end
