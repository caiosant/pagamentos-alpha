require 'rails_helper'

describe 'Pix setting API' do
  context 'GET /api/v1/pix_settings' do
    it 'should get all settings from requesting company'
    it 'returns no settings'
  end

  context 'GET /api/v1/pix_settings/:token' do
    it 'should get corresponding setting from requesting company'
    it 'should return 404 if property does not exist'
    it 'should return 500 if database is not available'
  end
end