require 'rails_helper'

describe 'company authenticate into the system' do
  context 'on pix_setting path' do
    it 'successfully' do
      owner = create(:user, :complete_company_owner)
      company = owner.company
      company.accepted!

      create(:pix_setting, company: company)
      get '/api/v1/pix_settings', headers: { companyToken: company.token }

      expect(response).to have_http_status(200)
    end

    it 'fails because token wasnt passed' do
      owner = create(:user, :complete_company_owner)
      company = owner.company
      company.accepted!

      create(:pix_setting, company: company)
      get '/api/v1/pix_settings'

      expect(response).to have_http_status(401)
    end

    it 'fails because token doesnt exist' do
      owner = create(:user, :complete_company_owner)
      company = owner.company
      company.accepted!

      create(:pix_setting, company: company)
      get '/api/v1/pix_settings', headers: { companyToken: 'a' * 20 }

      expect(response).to have_http_status(401)
    end
  end
end
