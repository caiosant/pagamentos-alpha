require 'rails_helper'

describe 'Credit Card setting API' do
  context 'GET /api/v1/credit_card_settings/:company_token' do
    it 'should get all settings from requesting company' do
      owner = create(:user, :complete_company_owner)
      company = owner.company
      company.accepted!

      other_owner = create(:user, :complete_company_owner)
      other_company = other_owner.company
      other_company.accepted!

      credit_card_settings = create_list(:credit_card_setting, 3, company: company)
      credit_card_settings[2].payment_method.disabled!
      create_list(:credit_card_setting, 2, company: other_company)

      get "/api/v1/credit_card_settings/#{company.token}"

      expect(response).to have_http_status(200)
      expect(parsed_body.first[:company_code]).to eq(credit_card_settings.first.company_code)
      expect(parsed_body.first[:token]).to eq(credit_card_settings.first.token)
      expect(parsed_body.first[:payment_method][:name]).to eq(credit_card_settings.first.payment_method.name)
      expect(parsed_body.second[:company_code]).to eq(credit_card_settings.second.company_code)
      expect(parsed_body.second[:token]).to eq(credit_card_settings.second.token)
      expect(parsed_body.count).to eq(2)
    end

    it 'returns no settings' do
      owner = create(:user, :complete_company_owner)
      company = owner.company
      company.accepted!

      owner2 = create(:user, :complete_company_owner)
      company2 = owner2.company
      company2.accepted!

      create_list(:credit_card_setting, 2, company: company2)

      get "/api/v1/credit_card_settings/#{company.token}"

      expect(response).to have_http_status(200)
      expect(parsed_body).to be_empty
    end
  end

  context 'GET /api/v1/credit_card_settings/:token' do
    it 'should get corresponding setting from requesting company'
    it 'should return 404 if property does not exist'
    it 'should return 500 if database is not available'
  end
end
