require 'rails_helper'

RSpec.describe BoletoSetting, type: :model do
  it 'but fails when entering non existing bank code'
  it 'but fails when entering invalid agency number(regex validation)'
  it 'but fails when entering invalid account number(regex validation)'
  it 'but fails when leaving everything blank'
end
