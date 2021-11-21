require 'rails_helper'

describe 'Owner creates credit card payment setting' do
    xit 'successfully' do
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
    it 'but fails when entering invalid code(regex validation)'
    it 'but fails when leaving everything blank'
end