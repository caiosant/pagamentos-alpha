require 'rails_helper'

describe 'Owner creates pix payment setting' do
    it 'successfully' do
      owner = create(:user, :complete_company_owner)
      company = owner.company
      company.accepted!

      pix_method, pix_method2, pix_method3  = create_list(:payment_method, 3, :pix)

      login_as owner, scope: :user
      visit company_path owner.company
      click_on 'Meios de pagamento configurados'
      click_on 'Configurar novo pix'

      fill_in 'Chave PIX', with: '317283472634723'
      fill_in 'Código do banco', with: '245'
      select pix_method.name, from: 'Meio de pagamento'
      click_on 'Criar Pagamento PIX'

      expect(current_path).to eq(company_payment_settings_path owner.company)
      expect(page).to have_content('Pagamento configurado com sucesso')
      expect(page).to have_content('Chave PIX: 317283472634723')
      expect(page).to have_content('Código do banco: 245')
      expect(owner.company.payment_settings).to include(PixSetting.first)
    end

    it 'but fails when entering invalid pix key(regex validation)'
    it 'but fails when entering non existing bank code'
    it 'but fails when leaving everything blank'
end

# ('Chave PIX')
#     expect(page).to have_content('Código do banco')
#     expect(page).to have_content('Meio de pagamento')
