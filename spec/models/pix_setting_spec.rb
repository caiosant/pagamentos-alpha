require 'rails_helper'

RSpec.describe PixSetting, type: :model do
  context 'validations' do
    it { should validate_presence_of(:pix_key) }
    it { should validate_presence_of(:bank_code) }
  end

  context 'associations' do
    it { should belong_to :company }
    it { should belong_to :payment_method }
  end

  it 'but fails when entering non existing bank code'
end
