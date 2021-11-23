require 'rails_helper'

RSpec.describe CreditCardSetting, type: :model do
  context 'validations' do
    it { should validate_presence_of(:company_code) }
  end

  context 'associations' do
    it { should belong_to :company }
    it {
      should belong_to(:payment_method)
        .conditions(type_of: :credit_card)
    }
  end

  it 'successfully' do
    credit_card_setting = build(:credit_card_setting)
    expect(credit_card_setting.save).to eq(true)
  end
end
