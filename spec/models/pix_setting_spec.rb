require 'rails_helper'

RSpec.describe PixSetting, type: :model do
  it 'fails when entering invalid pix key(regex validation)' do
    pix_setting = create(:pix_setting)
    byebug
  end
  it 'but fails when entering non existing bank code'
  it 'but fails when leaving everything blank'
end
