require 'rails_helper'

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

        customer_payment_method = parsed_body[:customer_payment_method]
        expect(response).to have_http_status(201)
        expect(CustomerPaymentMethod.count).to eq(1)
        expect(customer_payment_method[:token]).to eq('hPxFizxVM5p5mNpFdOsf')
        expect(customer_payment_method[:payment_method][:name]).to eq(pix_method.name)
        expect(customer_payment_method[:payment_method][:type_of]).to eq(pix_method.type_of)
        expect(customer_payment_method[:customer][:token]).to eq(customer.token)
        expect(customer_payment_method[:company][:legal_name]).to eq(owner.company.legal_name)
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

        customer_payment_method = parsed_body[:customer_payment_method]
        expect(response).to have_http_status(201)
        expect(CustomerPaymentMethod.count).to eq(1)
        expect(customer_payment_method[:token]).to eq('hPxFizxVM5p5mNpFdOsf')
        expect(customer_payment_method[:payment_method][:name]).to eq(boleto_method.name)
        expect(customer_payment_method[:payment_method][:type_of]).to eq(boleto_method.type_of)
        expect(customer_payment_method[:customer][:token]).to eq(customer.token)
        expect(customer_payment_method[:company][:legal_name]).to eq(owner.company.legal_name)
      end

      it 'with credit card' do
        owner = create(:user, :complete_company_owner)
        owner.company.accepted!
        customer = create(:customer, company: owner.company)
        credit_card_method = create(:payment_method, :credit_card)
        credit_card_setting = create(:credit_card_setting, company: owner.company, payment_method: credit_card_method)
        company_payment_setting, = owner.company.payment_settings

        allow(SecureRandom).to receive(:alphanumeric).with(20).and_return('hPxFizxVM5p5mNpFdOsf')

        customer_payment_method_params = {
          customer_payment_method: {
            customer_token: customer.token,
            payment_method_token: company_payment_setting.token,
            credit_card_name: 'Credit Card 1',
            credit_card_number: '4929513324664053',
            credit_card_expiration_date: 3.months.from_now,
            credit_card_security_code: '123'
          }
        }
        post '/api/v1/customer_payment_method',
          params: customer_payment_method_params,
          headers: { 'companyToken' => owner.company.token }

        customer_payment_method = parsed_body[:customer_payment_method]
        expect(response).to have_http_status(201)
        expect(CustomerPaymentMethod.count).to eq(1)
        expect(customer_payment_method[:token]).to eq('hPxFizxVM5p5mNpFdOsf')
        expect(customer_payment_method[:payment_method][:name]).to eq(credit_card_method.name)
        expect(customer_payment_method[:payment_method][:type_of]).to eq(credit_card_method.type_of)
        expect(customer_payment_method[:customer][:token]).to eq(customer.token)
        expect(customer_payment_method[:company][:legal_name]).to eq(owner.company.legal_name)
      end
    end

    context '400 error' do
      it 'should inform company token on headers' do
        owner = create(:user, :complete_company_owner)
        owner.company.accepted!
        customer = create(:customer, company: owner.company)
        pix_method = create(:payment_method, :pix)
        pix_setting = create(:pix_setting, company: owner.company, payment_method: pix_method)
        company_payment_setting, = owner.company.payment_settings

        customer_payment_method_params = {
          customer_payment_method: {
            customer_token: customer.token,
            payment_method_token: company_payment_setting.token
          }
        }
        post '/api/v1/customer_payment_method', params: customer_payment_method_params

        expect(response).to have_http_status(401)
        expect(parsed_body[:message]). to eq('Há algo errado com sua autenticação.')
        expect(CustomerPaymentMethod.count).to eq(0)
      end

      it 'should inform customer token' do
        owner = create(:user, :complete_company_owner)
        owner.company.accepted!
        pix_method = create(:payment_method, :pix)
        pix_setting = create(:pix_setting, company: owner.company, payment_method: pix_method)
        company_payment_setting, = owner.company.payment_settings

        customer_payment_method_params = {
          customer_payment_method: {
            customer_token: '',
            payment_method_token: company_payment_setting.token
          }
        }
        post '/api/v1/customer_payment_method',
          params: customer_payment_method_params,
          headers: { 'companyToken' => owner.company.token }

        customer_payment_method = parsed_body[:request][:customer_payment_method]
        expect(response).to have_http_status(422)
        expect(CustomerPaymentMethod.count).to eq(0)
        expect(parsed_body[:message]). to eq('Requisição inválida')
        expect(parsed_body[:errors][:customer].first).to eq('é obrigatório(a)')
        expect(customer_payment_method[:payment_method][:name]).to eq(pix_method.name)
        expect(customer_payment_method[:payment_method][:type_of]).to eq(pix_method.type_of)
        expect(customer_payment_method[:company][:legal_name]).to eq(owner.company.legal_name)
        expect(customer_payment_method[:customer]).to be_nil
      end

      it 'should inform payment method token' do
        owner = create(:user, :complete_company_owner)
        owner.company.accepted!
        customer = create(:customer, company: owner.company)
        pix_method = create(:payment_method, :pix)
        pix_setting = create(:pix_setting, company: owner.company, payment_method: pix_method)

        customer_payment_method_params = {
          customer_payment_method: {
            customer_token: customer.token,
            payment_method_token: ''
          }
        }
        post '/api/v1/customer_payment_method',
          params: customer_payment_method_params,
          headers: { 'companyToken' => owner.company.token }

        customer_payment_method = parsed_body[:request][:customer_payment_method]
        expect(response).to have_http_status(422)
        expect(CustomerPaymentMethod.count).to eq(0)
        expect(parsed_body[:message]). to eq('Requisição inválida')
        expect(parsed_body[:errors][:payment_method].first).to eq('é obrigatório(a)')
        expect(customer_payment_method[:customer][:token]).to eq(customer.token)
        expect(customer_payment_method[:company][:legal_name]).to eq(owner.company.legal_name)
        expect(customer_payment_method[:payment_method]).to be_nil
      end

      it 'should inform credit card name' do
        owner = create(:user, :complete_company_owner)
        owner.company.accepted!
        customer = create(:customer, company: owner.company)
        credit_card_method = create(:payment_method, :credit_card)
        credit_card_setting = create(:credit_card_setting, company: owner.company, payment_method: credit_card_method)
        company_payment_setting, = owner.company.payment_settings

        customer_payment_method_params = {
          customer_payment_method: {
            customer_token: customer.token,
            payment_method_token: company_payment_setting.token,
            credit_card_name: '',
            credit_card_number: '4929513324664053',
            credit_card_expiration_date: 3.months.from_now,
            credit_card_security_code: '123'
          }
        }
        post '/api/v1/customer_payment_method',
          params: customer_payment_method_params,
          headers: { 'companyToken' => owner.company.token }

        customer_payment_method = parsed_body[:request][:customer_payment_method]
        expect(response).to have_http_status(422)
        expect(CustomerPaymentMethod.count).to eq(0)
        expect(parsed_body[:message]). to eq('Requisição inválida')
        expect(parsed_body[:errors][:credit_card_name].first).to eq('não pode ficar em branco')
        expect(customer_payment_method[:customer][:token]).to eq(customer.token)
        expect(customer_payment_method[:company][:legal_name]).to eq(owner.company.legal_name)
        expect(customer_payment_method[:payment_method][:name]).to eq(credit_card_method.name)
        expect(customer_payment_method[:payment_method][:type_of]).to eq(credit_card_method.type_of)
      end

      it 'should inform credit card number' do
        owner = create(:user, :complete_company_owner)
        owner.company.accepted!
        customer = create(:customer, company: owner.company)
        credit_card_method = create(:payment_method, :credit_card)
        credit_card_setting = create(:credit_card_setting, company: owner.company, payment_method: credit_card_method)
        company_payment_setting, = owner.company.payment_settings

        customer_payment_method_params = {
          customer_payment_method: {
            customer_token: customer.token,
            payment_method_token: company_payment_setting.token,
            credit_card_name: 'Credit Card 1',
            credit_card_number: '',
            credit_card_expiration_date: 3.months.from_now,
            credit_card_security_code: '123'
          }
        }
        post '/api/v1/customer_payment_method',
          params: customer_payment_method_params,
          headers: { 'companyToken' => owner.company.token }

        customer_payment_method = parsed_body[:request][:customer_payment_method]
        expect(response).to have_http_status(422)
        expect(CustomerPaymentMethod.count).to eq(0)
        expect(parsed_body[:message]). to eq('Requisição inválida')
        expect(parsed_body[:errors][:credit_card_number].first).to eq('não pode ficar em branco')
        expect(customer_payment_method[:customer][:token]).to eq(customer.token)
        expect(customer_payment_method[:company][:legal_name]).to eq(owner.company.legal_name)
        expect(customer_payment_method[:payment_method][:name]).to eq(credit_card_method.name)
        expect(customer_payment_method[:payment_method][:type_of]).to eq(credit_card_method.type_of)
      end

      it 'should inform credit card expiration date' do
        owner = create(:user, :complete_company_owner)
        owner.company.accepted!
        customer = create(:customer, company: owner.company)
        credit_card_method = create(:payment_method, :credit_card)
        credit_card_setting = create(:credit_card_setting, company: owner.company, payment_method: credit_card_method)
        company_payment_setting, = owner.company.payment_settings

        customer_payment_method_params = {
          customer_payment_method: {
            customer_token: customer.token,
            payment_method_token: company_payment_setting.token,
            credit_card_name: 'Credit Card 1',
            credit_card_number: '4929513324664053',
            credit_card_expiration_date: '',
            credit_card_security_code: '123'
          }
        }
        post '/api/v1/customer_payment_method',
          params: customer_payment_method_params,
          headers: { 'companyToken' => owner.company.token }

        customer_payment_method = parsed_body[:request][:customer_payment_method]
        expect(response).to have_http_status(422)
        expect(CustomerPaymentMethod.count).to eq(0)
        expect(parsed_body[:message]). to eq('Requisição inválida')
        expect(parsed_body[:errors][:credit_card_expiration_date].first).to eq('não pode ficar em branco')
        expect(customer_payment_method[:customer][:token]).to eq(customer.token)
        expect(customer_payment_method[:company][:legal_name]).to eq(owner.company.legal_name)
        expect(customer_payment_method[:payment_method][:name]).to eq(credit_card_method.name)
        expect(customer_payment_method[:payment_method][:type_of]).to eq(credit_card_method.type_of)
      end

      it 'should inform credit card security code' do
        owner = create(:user, :complete_company_owner)
        owner.company.accepted!
        customer = create(:customer, company: owner.company)
        credit_card_method = create(:payment_method, :credit_card)
        credit_card_setting = create(:credit_card_setting, company: owner.company, payment_method: credit_card_method)
        company_payment_setting, = owner.company.payment_settings

        customer_payment_method_params = {
          customer_payment_method: {
            customer_token: customer.token,
            payment_method_token: company_payment_setting.token,
            credit_card_name: 'Credit Card 1',
            credit_card_number: '4929513324664053',
            credit_card_expiration_date: 3.months.from_now,
            credit_card_security_code: ''
          }
        }
        post '/api/v1/customer_payment_method',
          params: customer_payment_method_params,
          headers: { 'companyToken' => owner.company.token }

        customer_payment_method = parsed_body[:request][:customer_payment_method]
        expect(response).to have_http_status(422)
        expect(CustomerPaymentMethod.count).to eq(0)
        expect(parsed_body[:message]). to eq('Requisição inválida')
        expect(parsed_body[:errors][:credit_card_security_code].first).to eq('não pode ficar em branco')
        expect(customer_payment_method[:customer][:token]).to eq(customer.token)
        expect(customer_payment_method[:company][:legal_name]).to eq(owner.company.legal_name)
        expect(customer_payment_method[:payment_method][:name]).to eq(credit_card_method.name)
        expect(customer_payment_method[:payment_method][:type_of]).to eq(credit_card_method.type_of)
      end

      it 'should inform credit card invalid when expired expiration date' do
        owner = create(:user, :complete_company_owner)
        owner.company.accepted!
        customer = create(:customer, company: owner.company)
        credit_card_method = create(:payment_method, :credit_card)
        credit_card_setting = create(:credit_card_setting, company: owner.company, payment_method: credit_card_method)
        company_payment_setting, = owner.company.payment_settings

        customer_payment_method_params = {
          customer_payment_method: {
            customer_token: customer.token,
            payment_method_token: company_payment_setting.token,
            credit_card_name: 'Credit Card 1',
            credit_card_number: '4929513324664053',
            credit_card_expiration_date: Date.yesterday,
            credit_card_security_code: '123'
          }
        }

        post '/api/v1/customer_payment_method',
          params: customer_payment_method_params,
          headers: { 'companyToken' => owner.company.token }

        customer_payment_method = parsed_body[:request][:customer_payment_method]
        expect(response).to have_http_status(422)
        expect(CustomerPaymentMethod.count).to eq(0)
        expect(parsed_body[:message]). to eq('Requisição inválida')
        expect(parsed_body[:errors][:credit_card_name].first).to eq('inválido(a)')
        expect(parsed_body[:errors][:credit_card_number].first).to eq('inválido(a)')
        expect(parsed_body[:errors][:credit_card_expiration_date].first).to eq('inválido(a)')
        expect(parsed_body[:errors][:credit_card_security_code].first).to eq('inválido(a)')
        expect(customer_payment_method[:customer][:token]).to eq(customer.token)
        expect(customer_payment_method[:company][:legal_name]).to eq(owner.company.legal_name)
        expect(customer_payment_method[:payment_method][:name]).to eq(credit_card_method.name)
        expect(customer_payment_method[:payment_method][:type_of]).to eq(credit_card_method.type_of)
      end
    end

  end
end
