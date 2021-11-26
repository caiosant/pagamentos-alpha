require 'rails_helper'

describe 'Customer API' do
    context 'POST /api/v1/customer' do
        it 'should save a new customer' do
            owner = create(:user, :complete_company_owner)

            owner.company.accepted!
            customer_params = { customer: { name: 'Caio Silva', 
                                            cpf: '41492765872'} }

            allow(SecureRandom).to receive(:alphanumeric).with(20).and_return('LI5YuUJrZuJSB6uPH2jm')

            post '/api/v1/customer', params: customer_params, headers: { companyToken: owner.company.token }

            expect(response).to have_http_status(201)
            expect(response.content_type).to include('application/json')
            expect(parsed_body[:name]).to eq('Caio Silva')
            expect(parsed_body[:cpf]).to eq('41492765872')
            expect(parsed_body[:customer_token]).to eq('LI5YuUJrZuJSB6uPH2jm')
        end

        it 'should return error about name' do
            owner = create(:user, :complete_company_owner)

            owner.company.accepted!
            customer_params = { customer: { name: '', 
                                            cpf: '41492765872'} }

            allow(SecureRandom).to receive(:alphanumeric).with(20).and_return('LI5YuUJrZuJSB6uPH2jm')

            post '/api/v1/customer', params: customer_params, headers: { companyToken: owner.company.token }

            expect(response).to have_http_status(422)
            expect(response.content_type).to include('application/json')
            expect(parsed_body[:name]).to eq('Caio Silva')
            expect(parsed_body[:cpf]).to eq('41492765872')
            expect(parsed_body[:customer_token]).to eq('LI5YuUJrZuJSB6uPH2jm')
        end
    end
end