require 'rails_helper'

describe 'User changes payment settings statuses' do
  context 'pix_setting' do
    it 'can be disabled' do
      owner = create(:user, :complete_company_owner)
      company = owner.company
      company.accepted!
      pix_setting = create(:pix_setting, company: company)

      login_as owner, scope: :user
      visit company_payment_settings_path company

      within("##{pix_setting.token}") do
        click_on 'Desabilitar'
      end

      expect(page).to have_content('Desabilitado')
    end

    it 'can be enabled' do
      owner = create(:user, :complete_company_owner)
      company = owner.company
      company.accepted!
      pix_setting = create(:pix_setting, company: company)
      pix_setting.disabled!

      login_as owner, scope: :user
      visit company_payment_settings_path company

      within("##{pix_setting.token}") do
        click_on 'Habilitar'
      end

      expect(page).to have_content('Habilitado')
    end
  end

  context 'boleto_setting' do
    it 'can be disabled'
    it 'can be enabled'
  end

  context 'credit_card_setting' do
    it 'can be disabled'
    it 'can be enabled'
  end
end
