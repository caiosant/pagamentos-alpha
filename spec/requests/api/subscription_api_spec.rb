require 'rails_helper'

describe 'Subscription API' do
  context 'POST /api/v1/subscriptions' do
    it 'successfully' do
      owner = create(:user, :complete_company_owner)
      company = owner.company
      company.accepted!

      post '/api/v1/subscriptions',
           params: { subscription: { name: 'Assinatura de LOL' } },
           headers: { companyToken: company.token }

      subscription = Subscription.last

      expect(response).to have_http_status(201)
      expect(parsed_body[:name]).to eq(subscription.name)
      expect(parsed_body[:token]).to eq(subscription.token)
    end

    it 'fail because name is blank' do
      owner = create(:user, :complete_company_owner)
      company = owner.company
      company.accepted!

      post '/api/v1/subscriptions',
           params: { subscription: { name: '' } },
           headers: { companyToken: company.token }

      expect(response).to have_http_status(422)
      expect(parsed_body[:errors][:name]).to eq(['não pode ficar em branco'])
    end
  end
  context 'GET /api/v1/subscriptions' do
    it 'should get all correspondig subscriptions' do
      owner = create(:user, :complete_company_owner)
      company = owner.company
      company.accepted!

      other_owner = create(:user, :complete_company_owner)
      other_company = other_owner.company
      other_company.accepted!

      subscriptions = create_list(:subscription, 3, company: company)
      subscriptions[2].disabled!
      create_list(:subscription, 2, company: other_company)

      get '/api/v1/subscriptions', headers: { companyToken: company.token }

      expect(response).to have_http_status(200)
      expect(parsed_body.first[:name]).to eq(subscriptions.first.name)
      expect(parsed_body.first[:token]).to eq(subscriptions.first.token)
      expect(parsed_body.second[:name]).to eq(subscriptions.second.name)
      expect(parsed_body.second[:token]).to eq(subscriptions.second.token)
      expect(parsed_body.count).to eq(2)
    end

    it 'return no subscription' do
      owner = create(:user, :complete_company_owner)
      company = owner.company
      company.accepted!

      owner2 = create(:user, :complete_company_owner)
      company2 = owner2.company
      company2.accepted!

      create_list(:subscription, 2, company: company2)

      get '/api/v1/subscriptions', headers: { companyToken: company.token }

      expect(response).to have_http_status(200)
      expect(parsed_body).to be_empty
    end
  end
  context 'GET /api/v1/subscriptions/:token' do
    it 'should get correspondig subscription' do
      owner = create(:user, :complete_company_owner)
      company = owner.company
      company.accepted!

      subscriptions = create_list(:subscription, 3, company: company)
      subscriptions.first.disabled!

      get "/api/v1/subscriptions/#{subscriptions.first.token}", headers: { companyToken: company.token }

      expect(response).to have_http_status(200)
      expect(parsed_body[:name]).to eq(subscriptions.first.name)
      expect(parsed_body[:token]).to eq(subscriptions.first.token)
      expect(parsed_body[:status]).to eq(subscriptions.first.status)
    end

    it 'should return 404 if subscription does not exist' do
      owner = create(:user, :complete_company_owner)
      company = owner.company
      company.accepted!

      get '/api/v1/subscriptions/hwduhdwuqhdwquhdqi', headers: { companyToken: company.token }

      expect(response).to have_http_status(404)
    end

    it 'should return 401 if setting is from another company' do
      owner = create(:user, :complete_company_owner)
      company = owner.company
      company.accepted!

      other_owner = create(:user, :complete_company_owner)
      other_company = other_owner.company
      other_company.accepted!

      other_subscription = create(:subscription, company: other_company)

      get "/api/v1/subscriptions/#{other_subscription.token}", headers: { companyToken: company.token }

      expect(response).to have_http_status(401)
    end
  end

  context 'POST /api/v1/subscriptions/:token/disable' do
    it 'successfully' do
      owner = create(:user, :complete_company_owner)
      company = owner.company
      company.accepted!

      subscription = create(:subscription, company: company)

      post "/api/v1/subscriptions/#{subscription.token}/disable", headers: { companyToken: company.token }

      expect(response).to have_http_status(204)
      expect(subscription.reload.status).to eq('disabled')
    end

    it 'should return 404 if subscription does not exist' do
      owner = create(:user, :complete_company_owner)
      company = owner.company
      company.accepted!

      post '/api/v1/subscriptions/hwduhdwuqhdwquhdqi/disable', headers: { companyToken: company.token }

      expect(response).to have_http_status(404)
    end

    it 'should return 401 if setting is from another company' do
      owner = create(:user, :complete_company_owner)
      company = owner.company
      company.accepted!

      other_owner = create(:user, :complete_company_owner)
      other_company = other_owner.company
      other_company.accepted!

      other_subscription = create(:subscription, company: other_company)

      post "/api/v1/subscriptions/#{other_subscription.token}/disable", headers: { companyToken: company.token }

      expect(response).to have_http_status(401)
    end
  end

  context 'POST /api/v1/subscriptions/:token/enable' do
    it 'successfully' do
      owner = create(:user, :complete_company_owner)
      company = owner.company
      company.accepted!

      subscription = create(:subscription, company: company)
      subscription.disabled!

      post "/api/v1/subscriptions/#{subscription.token}/enable", headers: { companyToken: company.token }

      expect(response).to have_http_status(204)
      expect(subscription.reload.status).to eq('enabled')
    end

    it 'should return 404 if subscription does not exist' do
      owner = create(:user, :complete_company_owner)
      company = owner.company
      company.accepted!

      post '/api/v1/subscriptions/hwduhdwuqhdwquhdqi/enable', headers: { companyToken: company.token }

      expect(response).to have_http_status(404)
    end

    it 'should return 401 if setting is from another company' do
      owner = create(:user, :complete_company_owner)
      company = owner.company
      company.accepted!

      other_owner = create(:user, :complete_company_owner)
      other_company = other_owner.company
      other_company.accepted!

      other_subscription = create(:subscription, company: other_company)

      post "/api/v1/subscriptions/#{other_subscription.token}/enable", headers: { companyToken: company.token }

      expect(response).to have_http_status(401)
    end
  end
end
