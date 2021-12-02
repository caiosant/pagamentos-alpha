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
end
