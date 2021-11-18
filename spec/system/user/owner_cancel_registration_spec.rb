require 'rails_helper'

describe 'Owner cancel registration' do
  it 'successfully' do
    owner = create(:user, owner: true, company: create(:company))
    
    login_as owner
    visit company_path owner.company
    click_on 'Cancelar pedido de registro'

    expect(current_path).to eq(edit_company_path owner.company)
    expect(page).to have_content('Você já se cadastrou no nosso sistema, mas agora precisa registrar a sua empresa! Preencha os dados abaixo para podermos conhecer sua empresa:')
    expect(owner.company.status).to eq('incomplete')
    expect(owner.company.any_essential_info_blank?).to eq(true)
  end
end
