require 'rails_helper'

RSpec.describe PixSetting, type: :model do
  context 'validations' do
    it { should validate_presence_of(:pix_key) }
    it { should validate_presence_of(:bank_code) }
  end

  context 'associations' do
    it { should belong_to :company }
    it {
      should belong_to(:payment_method)
        .conditions(type_of: :pix)
    }
  end

  it 'successfully' do
    pix_setting = build(:pix_setting)
    expect(pix_setting.save).to eq(true)
  end

  it 'but fails when entering non existing bank code' do
    pix_setting = build(:pix_setting, bank_code: '21313213131')
    expect(pix_setting.save).to eq(false)
  end
end
