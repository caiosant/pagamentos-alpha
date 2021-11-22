require 'rails_helper'

RSpec.describe CreditCardSetting, type: :model do
  context 'validations' do
    it { should validate_presence_of(:company_code) }
  end

  context 'associations' do
    it { should belong_to :company }
    it { should belong_to :payment_method }
  end

  xit 'but fails when entering invalid code(regex validation)'
  xit 'but fails when leaving everything blank'
end
