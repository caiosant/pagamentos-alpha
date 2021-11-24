require 'rails_helper'

describe 'Owner changes subscription status' do
  it 'to disabled successfully' do
    owner = create(:user, :complete_company_owner)
    owner.company.accepted!
    subscription = create(:subscription, company: owner.company)

    login_as owner, scope: :user
    visit subscription_path subscription
    click_on 'Desabilitar'

    expect(subscription.reload.status).to eq 'disabled'
  end

  it 'to enabled successfully' do
    owner = create(:user, :complete_company_owner)
    owner.company.accepted!
    subscription = create(:subscription, company: owner.company)
    subscription.disabled!

    login_as owner, scope: :user
    visit subscription_path subscription
    click_on 'Habilitar'

    expect(subscription.reload.status).to eq 'enabled'
  end

  context 'but cant see two buttons at once' do
    it 'only disabled' do
      owner = create(:user, :complete_company_owner)
      owner.company.accepted!
      subscription = create(:subscription, company: owner.company)
  
      login_as owner, scope: :user
      visit subscription_path subscription
      
      expect(page).to have_link('Desabilitar')
      expect(page).to_not have_link('Habilitar')
    end

    it 'only enabled' do
      owner = create(:user, :complete_company_owner)
      owner.company.accepted!
      subscription = create(:subscription, company: owner.company)
      subscription.disabled!

      login_as owner, scope: :user
      visit subscription_path subscription
      
      expect(page).to_not have_link('Desabilitar')
      expect(page).to have_link('Habilitar')
    end
  end
end
