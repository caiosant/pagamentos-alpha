require 'rails_helper'

describe 'Owner changes subscription status' do
  it 'to disabled successfully' do
    owner = create(:user, :complete_company_owner)
    subscription = create(:subscription, company: owner.company)

    login_as owner, scope: :user
    visit subscription_path subscription
    click_on 'Desabilitar'

    subscription.reload
    expect(subscription).to be_disabled
  end

  it 'to enabled successfully' do
    owner = create(:user, :complete_company_owner)
    subscription = create(:subscription, company: owner.company)
    subscription.disabled!

    login_as owner, scope: :user
    visit subscription_path subscription
    click_on 'Habilitar'

    subscription.reload
    expect(subscription).to be_disabled
  end

  context 'but cant see two buttons at once' do
    it 'only disabled' do
      owner = create(:user, :complete_company_owner)
      subscription = create(:subscription, company: owner.company)
      subscription.enabled!
  
      login_as owner, scope: :user
      visit subscription_path subscription
      expect(page).to have_link('Desabilitar')
      expect(page).to_not have_link('Habilitar')
    end

    it 'only enabled' do
      owner = create(:user, :complete_company_owner)
      subscription = create(:subscription, company: owner.company)

      login_as owner, scope: :user
      visit subscription_path subscription
      expect(page).to_not have_link('Desabilitar')
      expect(page).to have_link('Habilitar')
    end
  end
end
