require 'rails_helper'

describe 'Boleto setting API' do
  context 'GET /api/v1/boleto_settings/:company_token' do
    it 'should get all settings from requesting company' do
      owner = create(:user, :complete_company_owner)
      company = owner.company
      company.accepted!

      other_owner = create(:user, :complete_company_owner)
      other_company = other_owner.company
      other_company.accepted!

      boleto_settings = create_list(:boleto_setting, 3, company: company)
      boleto_settings[2].payment_method.disabled!
      invisible_boleto_setting = create_list(:boleto_setting, 2, company: other_company)

      get "/api/v1/boleto_settings/#{company.token}"

      expect(response).to have_http_status(200)
      expect(parsed_body.first[:agency_number]).to eq(boleto_settings.first.agency_number)
      expect(parsed_body.first[:account_number]).to eq(boleto_settings.first.account_number)
      expect(parsed_body.first[:token]).to eq(boleto_settings.first.token)
      expect(parsed_body.first[:bank_code]).to eq(boleto_settings.first.bank_code)
      expect(parsed_body.first[:payment_method][:name]).to eq(boleto_settings.first.payment_method.name)
      expect(parsed_body.second[:agency_number]).to eq(boleto_settings.second.agency_number)
      expect(parsed_body.second[:token]).to eq(boleto_settings.second.token)
      expect(parsed_body.count).to eq(2)
    end

    it 'returns no settings' do
      owner = create(:user, :complete_company_owner)
      company = owner.company
      company.accepted!

      owner2 = create(:user, :complete_company_owner)
      company2 = owner2.company
      company2.accepted!

      invisible_boleto_setting = create_list(:boleto_setting, 2, company: company2)

      get "/api/v1/boleto_settings/#{company.token}"

      expect(response).to have_http_status(200)
      expect(parsed_body).to be_empty
    end
  end

  context 'GET /api/v1/boleto_settings/:token' do
    it 'should get corresponding setting from requesting company'
    it 'should return 404 if property does not exist'
    it 'should return 500 if database is not available'
  end
end