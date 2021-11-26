require 'rails_helper'

# recebe token da empresa, cpf, meio de pagamento, 
# numero do cartão + validade (só cartão)
# retorna token do cliente
describe 'CustomerPaymentMethod API' do
  context 'POST /api/v1/customer_payment_method' do
    context 'successfully' do
      it 'with pix' do
        owner = create(:user, :complete_company_owner)
        owner.company.accepted!
        customer = create(:customer, company: owner.company)
        pix_method = create(:payment_method, :pix)
        pix_setting = create(:pix_setting, company: owner.company, payment_method: pix_method)
        company_payment_setting, = owner.company.payment_settings

        allow(SecureRandom).to receive(:alphanumeric).with(20).and_return('hPxFizxVM5p5mNpFdOsf')

        customer_payment_method_params = {
          customer_payment_method: {
            customer_token: customer.token,
            payment_method_token: company_payment_setting.token
          }
        }
        post '/api/v1/customer_payment_method',
          params: customer_payment_method_params,
          headers: { 'companyToken' => owner.company.token }

        expect(response).to have_http_status(201)
        expect(parsed_body[:customer_payment_method_token]).to eq('hPxFizxVM5p5mNpFdOsf')
        expect(CustomerPaymentMethod.count).to eq(1)
      end

      it 'with boleto' do
        owner = create(:user, :complete_company_owner)
        owner.company.accepted!
        customer = create(:customer, company: owner.company)
        boleto_method = create(:payment_method, :boleto)
        boleto_setting = create(:boleto_setting, company: owner.company, payment_method: boleto_method)
        company_payment_setting, = owner.company.payment_settings

        allow(SecureRandom).to receive(:alphanumeric).with(20).and_return('hPxFizxVM5p5mNpFdOsf')

        customer_payment_method_params = {
          customer_payment_method: {
            customer_token: customer.token,
            payment_method_token: company_payment_setting.token
          }
        }
        post '/api/v1/customer_payment_method',
          params: customer_payment_method_params,
          headers: { 'companyToken' => owner.company.token }

        expect(response).to have_http_status(201)
        expect(parsed_body[:customer_payment_method_token]).to eq('hPxFizxVM5p5mNpFdOsf')
        expect(CustomerPaymentMethod.count).to eq(1)
      end

      it 'with credit card' do
        owner = create(:user, :complete_company_owner)
        owner.company.accepted!
        credit_card_method = create(:payment_method, :credit_card)
        credit_card_setting = create(:credit_card_setting, company: owner.company, payment_method: credit_card_method)
        company_payment_method = owner.company.list_payment_methods

        allow(SecureRandom).to receive(:alphanumeric).with(20).and_return('hPxFizxVM5p5mNpFdOsf')

        customer_params = {
          cpf: '111.111.111-11',
          payment_method_token: company_payment_method.token,
          credit_card_number: '47384876346537',
          credit_card_expiration_date: 3.month.from_now
        }

        post '/api/v1/customer_payment_method', params: {
          company_token: owner.company.token,
          customer: customer_params
        }

        expect(response).to have_http_status(200)
        expect(parsed_body[:customer_token]).to eq('hPxFizxVM5p5mNpFdOsf')
      end
    end

    context '400 error' do
      it 'should inform customer name' do
        owner = create(:user, :complete_company_owner)
        owner.company.accepted!
        credit_card_method = create(:payment_method, :credit_card)
        credit_card_setting = create(:credit_card_setting, company: owner.company, payment_method: credit_card_method)
        company_payment_method = owner.company.list_payment_methods

        customer_params = {
          company_token: owner.company.token,
          customer_name: '',
          cpf: '111.111.111-11',
          payment_method_token: company_payment_method.token,
          credit_card_number: '47384876346537',
          credit_card_expiration_date: 3.month.from_now
        }

        post '/api/v1/customer', params: { customer: customer_params }

        expect(response).to have_http_status(400)
        expect(response.parsed_body[:message]). to eq('Nome do cliente deve ser enviado')
      end

      it 'should inform CPF' do
        owner = create(:user, :complete_company_owner)
        owner.company.accepted!
        credit_card_method = create(:payment_method, :credit_card)
        credit_card_setting = create(:credit_card_setting, company: owner.company, payment_method: credit_card_method)
        company_payment_method = owner.company.list_payment_methods

        customer_params = {
          company_token: owner.company.token,
          cpf: '',
          payment_method_token: company_payment_method.token,
          credit_card_number: '47384876346537',
          credit_card_expiration_date: 3.month.from_now
        }

        post '/api/v1/customer', params: { customer: customer_params }

        expect(response).to have_http_status(400)
        expect(response.parsed_body[:message]). to eq('CPF deve ser enviado')
      end

      it 'should inform credit card number' do
        owner = create(:user, :complete_company_owner)
        owner.company.accepted!
        credit_card_method = create(:payment_method, :credit_card)
        credit_card_setting = create(:credit_card_setting, company: owner.company, payment_method: credit_card_method)
        company_payment_method, = owner.company.list_payment_methods

        customer_params = {
          company_token: owner.company.token,
          cpf: '111.111.111-11',
          payment_method_token: company_payment_method.token,
          credit_card_number: '',
          credit_card_expiration_date: 3.month.from_now
        }

        post '/api/v1/customer', params: { customer: customer_params }

        expect(response).to have_http_status(400)
        expect(response.parsed_body[:message]). to eq('Número do cartão de crédito deve ser enviado')
      end

      it 'should inform credit card expiration date' do
      end

      it 'should inform cpf' do
      end

      it 'should inform payment_method_id' do
      end

      it 'payment_method does not exist' do
      end

      it 'cannot create without company token' do
      end
    end
  end
end


