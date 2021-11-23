require 'rails_helper'

RSpec.describe BoletoSetting, type: :model do
  context 'presence' do
    it { should validate_presence_of(:agency_number) }
    it { should validate_presence_of(:account_number) }
    it { should validate_presence_of(:bank_code) }
  end

  context 'associations' do
    it { should belong_to :company }
    it {
      should belong_to(:payment_method)
        .conditions(type_of: :boleto)
    }
  end

  it 'successfully' do
    boleto_setting = build(:boleto_setting)
    expect(boleto_setting.save).to eq(true)
  end

  it 'but fails when entering non existing bank code' do
    boleto_setting = build(:boleto_setting, bank_code: '21313213131')
    expect(boleto_setting.save).to eq(false)
  end
end
