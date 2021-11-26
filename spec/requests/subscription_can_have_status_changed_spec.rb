require 'rails_helper'

describe 'Subscription can have status changed' do
    it 'unless user is from another company' do
      owner = create(:user, :complete_company_owner)
      owner.company.accepted!
      subscription = FactoryBot.create(:subscription, company: owner.company)

      owner2 = create(:user, :complete_company_owner)
      owner2.company.accepted!

      login_as owner2, scope: :user
      post disable_subscription_path subscription

      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq('Assinatura não pertence a esta empresa')
    end
end
