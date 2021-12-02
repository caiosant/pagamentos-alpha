require 'rails_helper'

describe 'Customer subscription API' do
  context 'GET /api/v1/customer_subscriptions' do
    it 'successfully' do
      customer_subscription = create(:customer_subscription)
      company = customer_subscription.company

      customer_subscriptions = create_list(:customer_subscription, 3, company: company)
      customer_subscriptions = [customer_subscription] + customer_subscriptions

      get "/api/v1/customer_subscriptions", headers: { companyToken: company.token }

      customer_subscriptions.each.with_index do |customer_subscription, position|
        parsed_customer_subscription = parsed_body[position][:customer_subscription]
        expect(parsed_customer_subscription[:renovation_date]).to eq(customer_subscription.renovation_date)
        expect(parsed_customer_subscription[:token]).to eq(customer_subscription.token)
        expect(parsed_customer_subscription[:status]).to eq(customer_subscription.status)
        expect(parsed_customer_subscription[:cost]).to eq(customer_subscription.cost.to_s)
        expect(parsed_customer_subscription[:product][:name]).to eq(customer_subscription.product.name)
        expect(parsed_customer_subscription[:product][:type_of]).to eq(customer_subscription.product.type_of)
        expect(parsed_customer_subscription[:product][:token]).to eq(customer_subscription.product.token)
      end
    end
  end

  context 'GET /api/v1/customer_subscriptions/:token' do
    it 'should get corresponding setting from requesting company' do
      owner = create(:user, :complete_company_owner)
      company = owner.company
      company.accepted!

      cc_settings = create_list(:credit_card_setting, 3, company: company)
      cc_settings.first.payment_method.disabled!

      get "/api/v1/credit_card_settings/#{cc_settings.first.token}", headers: { companyToken: company.token }

      expect(response).to have_http_status(200)
      expect(parsed_body[:credit_card_setting][:company_code]).to eq(cc_settings.first.company_code)
      expect(parsed_body[:credit_card_setting][:token]).to eq(cc_settings.first.token)
      expect(parsed_body[:credit_card_setting][:payment_method][:status]).to eq(cc_settings.first.payment_method.status)
      expect(parsed_body[:credit_card_setting][:payment_method][:name]).to eq(cc_settings.first.payment_method.name)
    end

    it 'should return 404 if setting does not exist' do
      owner = create(:user, :complete_company_owner)
      company = owner.company
      company.accepted!

      get '/api/v1/credit_card_settings/999', headers: { companyToken: company.token }

      expect(response).to have_http_status(404)
    end

    it 'should return 401 if setting is from another company' do
      owner = create(:user, :complete_company_owner)
      company = owner.company
      company.accepted!

      other_owner = create(:user, :complete_company_owner)
      other_company = other_owner.company
      other_company.accepted!

      other_credit_card_setting = create(:credit_card_setting, company: other_company)

      get "/api/v1/credit_card_settings/#{other_credit_card_setting.token}", headers: { companyToken: company.token }

      expect(response).to have_http_status(401)
    end

    it 'should return 500 if database is not available' do
      owner = create(:user, :complete_company_owner)
      company = owner.company
      company.accepted!

      credit_card_setting = create(:credit_card_setting, company: company)

      allow(CreditCardSetting).to receive(:find_by).and_raise(ActiveRecord::ActiveRecordError)

      get "/api/v1/credit_card_settings/#{credit_card_setting.id}", headers: { companyToken: company.token }

      expect(response).to have_http_status(500)
    end
  end
end
