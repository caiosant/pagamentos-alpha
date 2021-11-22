require 'rails_helper'

RSpec.describe BoletoSetting, type: :model do
  context 'validations' do
    it { should validate_presence_of(:agency_number) }
    it { should validate_presence_of(:account_number) }
    it { should validate_presence_of(:bank_code) }
  end

  context 'associations' do
    it { should belong_to :company }
    it { should belong_to :payment_method }
  end

  it 'but fails when entering non existing bank code'
  
  xit 'but fails when entering invalid agency number(regex validation)'
  xit 'but fails when entering invalid account number(regex validation)'
  xit 'but fails when leaving everything blank'
end
