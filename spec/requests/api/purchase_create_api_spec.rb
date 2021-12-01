require 'rails_helper'

describe 'Purchase API' do
  context 'Transaction can be created on POST /api/v1/purchases' do
    it 'successfully' do
      owner = create(:user, :complete_company_owner)
      company = owner.company
      company.accepted!

      product = FactoryBot.create(
        :product,
        company: company,
        type_of: 'single',
        name: 'Vídeo de Minecraft'
      )

      pix_setting = FactoryBot.create(
        :pix_setting,
        company: company,
        pix_key: '90803452a',
        bank_code: '001'
      )

      customer_payment_method = create(:customer_payment_method, :pix)

      post '/api/v1/purchases',
           params: { purchase: {
             product_token: product.token,
             payment_setting_token: pix_setting.token,
             payment_setting_type: 'pix',
             customer_payment_method_token: customer_payment_method.token
           } },
           headers: { companyToken: company.token }

      expect(response).to have_http_status(201)
      expect(parsed_body[:purchase][:product][:name]).to eq(product.name)
      expect(parsed_body[:purchase][:product][:token]).to eq(product.token)
      expect(parsed_body[:purchase][:type_of]).to eq('pix')
      expect(parsed_body[:purchase][:pix_setting][:token]).to eq(pix_setting.token)
      expect(parsed_body[:purchase][:customer_payment_method][:token]).to eq(customer_payment_method.token)
    end

    it 'but fails when product is subscription type' do
      owner = create(:user, :complete_company_owner)
      company = owner.company
      company.accepted!

      product = FactoryBot.create(
        :product,
        company: company,
        type_of: 'subscription',
        name: 'Vídeo de Minecraft'
      )

      pix_setting = FactoryBot.create(
        :pix_setting,
        company: company,
        pix_key: '90803452a',
        bank_code: '001'
      )

      customer_payment_method = create(:customer_payment_method, :pix)

      post '/api/v1/purchases',
           params: { purchase: {
             product_token: product.token,
             payment_setting_token: pix_setting.token,
             payment_setting_type: 'pix',
             customer_payment_method_token: customer_payment_method.token
           } },
           headers: { companyToken: company.token }

      expect(response).to have_http_status(422)
      expect(parsed_body[:errors][:product]).to eq(['não crie cobrança de assinatura diretamente pela API'])
    end
  end

  context 'GET /api/v1/purchases' do
    it 'successfully return all purchases' do
      owner = create(:user, :complete_company_owner)
      company = owner.company
      company.accepted!

      product = create(
        :product,
        company: company,
        type_of: 'single',
        name: 'Vídeo de CS:GO'
      )

      product2 = create(
        :product,
        company: company,
        type_of: 'single',
        name: 'Vídeo de CS:GO - 5k'
      )

      customer_payment_method = create(:customer_payment_method, :pix, company: company)

      purchase = create(
        :purchase,
        customer_payment_method: customer_payment_method,
        product: product,
        company: company
      )

      purchase2 = create(
        :purchase,
        customer_payment_method: customer_payment_method,
        product: product2,
        company: company
      )

      get '/api/v1/purchases', headers: { companyToken: company.token }

      first = parsed_body.first[:purchase]
      second = parsed_body.second[:purchase]

      expect(response).to have_http_status(200)
      expect(response.content_type).to include('application/json')
      expect(first[:type_of]).to eq('pix')
      expect(first[:cost]).to eq('9.99')
      expect(first[:paid_date]).to eq(purchase.paid_date.to_s)
      expect(first[:paid_date]).to eq(purchase.expiration_date.to_s)
      expect(first[:company][:legal_name]).to eq(company.legal_name)
      expect(first[:product][:name]).to eq(product.name)
      expect(first[:pix_setting][:token]).to eq(purchase.pix_setting.token)
      expect(first[:boleto_setting]).to eq(nil)
      expect(first[:credit_card_setting]).to eq(nil)
      expect(first[:customer_payment_method][:token]).to eq(customer_payment_method.token)
      expect(second[:type_of]).to eq('pix')
      expect(second[:cost]).to eq('9.99')
      expect(second[:paid_date]).to eq(purchase2.paid_date.to_s)
      expect(second[:paid_date]).to eq(purchase2.expiration_date.to_s)
      expect(second[:company][:legal_name]).to eq(company.legal_name)
      expect(second[:product][:name]).to eq(product2.name)
      expect(second[:pix_setting][:token]).to eq(purchase2.pix_setting.token)
      expect(second[:boleto_setting]).to eq(nil)
      expect(second[:credit_card_setting]).to eq(nil)
      expect(second[:customer_payment_method][:token]).to eq(customer_payment_method.token)
    end
  

    context 'with one query parameter' do
      it 'with query parameter: customer_token. And got successfully' do
        owner = create(:user, :complete_company_owner)
        company = owner.company
        company.accepted!

        product = create(
          :product,
          company: company,
          type_of: 'single',
          name: 'Vídeo de CS:GO'
        )

        product2 = create(
          :product,
          company: company,
          type_of: 'single',
          name: 'Vídeo de CS:GO - 5k'
        )

        customer_payment_method = create(:customer_payment_method, :pix, company: company)
        other_customer_payment_method = create(:customer_payment_method, :pix, company: company)

        purchase = create(
          :purchase,
          customer_payment_method: other_customer_payment_method,
          product: product,
          company: company
        )

        purchase2 = create(
          :purchase,
          customer_payment_method: customer_payment_method,
          product: product2,
          company: company
        )

        get "/api/v1/purchases?customer_token=#{other_customer_payment_method.customer.token}",
            headers: { companyToken: company.token }

        first = parsed_body.first

        expect(response).to have_http_status(200)
        expect(response.content_type).to include('application/json')
        expect(first[:purchase][:type_of]).to eq('pix')
        expect(first[:purchase][:cost]).to eq('9.99')
        expect(first[:purchase][:paid_date]).to eq(purchase.paid_date.to_s)
        expect(first[:purchase][:paid_date]).to eq(purchase.expiration_date.to_s)
        expect(first[:purchase][:company][:legal_name]).to eq(company.legal_name)
        expect(first[:purchase][:product][:name]).to eq(product.name)
        expect(first[:purchase][:pix_setting][:token]).to eq(purchase.pix_setting.token)
        expect(first[:purchase][:boleto_setting]).to eq(nil)
        expect(first[:purchase][:credit_card_setting]).to eq(nil)
        expect(first[:purchase][:customer_payment_method][:token]).to_not eq(customer_payment_method.token)
        expect(parsed_body).to_not include(purchase2.expiration_date.to_s)
        expect(parsed_body).to_not include(product2.name)
        expect(parsed_body).to_not include(purchase2.pix_setting.token)
        expect(parsed_body).to_not include(customer_payment_method.token)
      end

      it 'with query parameter: token. And got successfully' do
        owner = create(:user, :complete_company_owner)
        company = owner.company
        company.accepted!

        product = create(
          :product,
          company: company,
          type_of: 'single',
          name: 'Vídeo de CS:GO'
        )

        product2 = create(
          :product,
          company: company,
          type_of: 'single',
          name: 'Vídeo de CS:GO - 5k'
        )

        customer_payment_method = create(:customer_payment_method, :pix, company: company)
        other_customer_payment_method = create(:customer_payment_method, :credit_card, company: company)

        purchase = create(
          :purchase,
          customer_payment_method: other_customer_payment_method,
          product: product,
          type_of: 'credit_card',
          pix_setting: nil,
          credit_card_setting: create(:credit_card_setting),
          company: company
        )

        purchase2 = create(
          :purchase,
          customer_payment_method: customer_payment_method,
          product: product2,
          company: company
        )

        get '/api/v1/purchases?type=pix', headers: { companyToken: company.token }

        first = parsed_body.first

        expect(response).to have_http_status(200)
        expect(response.content_type).to include('application/json')
        expect(first[:purchase][:type_of]).to eq('pix')
        expect(first[:purchase][:cost]).to eq('9.99')
        expect(first[:purchase][:paid_date]).to eq(purchase2.paid_date.to_s)
        expect(first[:purchase][:paid_date]).to eq(purchase2.expiration_date.to_s)
        expect(first[:purchase][:company][:legal_name]).to eq(company.legal_name)
        expect(first[:purchase][:product][:name]).to eq(product2.name)
        expect(first[:purchase][:pix_setting][:token]).to eq(purchase2.pix_setting.token)
        expect(first[:purchase][:boleto_setting]).to eq(nil)
        expect(first[:purchase][:credit_card_setting]).to eq(nil)
        expect(first[:purchase][:customer_payment_method][:token]).to eq(customer_payment_method.token)
        expect(parsed_body).to_not include(purchase.expiration_date.to_s)
        expect(parsed_body).to_not include(product.name)
        expect(parsed_body).to_not include(purchase.credit_card_setting.token)
        expect(parsed_body).to_not include(other_customer_payment_method.token)
      end

      it 'with query parameter: product_token. And got successfully' do
        owner = create(:user, :complete_company_owner)
        company = owner.company
        company.accepted!

        product = create(
          :product,
          company: company,
          type_of: 'single',
          name: 'Vídeo de CS:GO'
        )

        product2 = create(
          :product,
          company: company,
          type_of: 'single',
          name: 'Vídeo de CS:GO - 5k'
        )

        customer_payment_method = create(:customer_payment_method, :pix, company: company)
        other_customer_payment_method = create(:customer_payment_method, :pix, company: company)

        purchase = create(
          :purchase,
          customer_payment_method: other_customer_payment_method,
          product: product,
          company: company
        )

        purchase2 = create(
          :purchase,
          customer_payment_method: customer_payment_method,
          product: product2,
          company: company
        )

        get "/api/v1/purchases?product_token=#{product.token}", headers: { companyToken: company.token }

        first = parsed_body.first

        expect(response).to have_http_status(200)
        expect(response.content_type).to include('application/json')
        expect(first[:purchase][:type_of]).to eq('pix')
        expect(first[:purchase][:cost]).to eq('9.99')
        expect(first[:purchase][:paid_date]).to eq(purchase.paid_date.to_s)
        expect(first[:purchase][:paid_date]).to eq(purchase.expiration_date.to_s)
        expect(first[:purchase][:company][:legal_name]).to eq(company.legal_name)
        expect(first[:purchase][:product][:name]).to eq(product.name)
        expect(first[:purchase][:pix_setting][:token]).to eq(purchase.pix_setting.token)
        expect(first[:purchase][:boleto_setting]).to eq(nil)
        expect(first[:purchase][:credit_card_setting]).to eq(nil)
        expect(first[:purchase][:customer_payment_method][:token]).to eq(other_customer_payment_method.token)
        expect(parsed_body).to_not include(purchase.expiration_date.to_s)
        expect(parsed_body).to_not include(product2.name)
        expect(parsed_body).to_not include(purchase2.pix_setting.token)
        expect(parsed_body).to_not include(customer_payment_method.token)
      end
    end

    context 'with tow query parameter' do
      it 'with query parameter: customer_token and product_token. And got successfully' do
        owner = create(:user, :complete_company_owner)
        company = owner.company
        company.accepted!

        product = create(
          :product,
          company: company,
          type_of: 'single',
          name: 'Vídeo de CS:GO'
        )

        product2 = create(
          :product,
          company: company,
          type_of: 'single',
          name: 'Vídeo de CS:GO - 5k'
        )

        product3 = create(
          :product,
          company: company,
          type_of: 'single',
          name: 'Vídeo de CS:GO - bgdew'
        )

        customer_payment_method = create(:customer_payment_method, :pix, company: company)
        other_customer_payment_method = create(:customer_payment_method, :pix, company: company)

        purchase = create(
          :purchase,
          customer_payment_method: other_customer_payment_method,
          product: product,
          company: company
        )

        purchase2 = create(
          :purchase,
          customer_payment_method: customer_payment_method,
          product: product2,
          company: company
        )

        purchase3 = create(
          :purchase,
          customer_payment_method: customer_payment_method,
          product: product3,
          company: company
        )

        get "/api/v1/purchases?customer_token=#{customer_payment_method.customer.token}&product_token=#{product2.token}",
            headers: { companyToken: company.token }

        first = parsed_body.first

        expect(response).to have_http_status(200)
        expect(response.content_type).to include('application/json')
        expect(first[:purchase][:type_of]).to eq('pix')
        expect(first[:purchase][:cost]).to eq('9.99')
        expect(first[:purchase][:paid_date]).to eq(purchase.paid_date.to_s)
        expect(first[:purchase][:paid_date]).to eq(purchase.expiration_date.to_s)
        expect(first[:purchase][:company][:legal_name]).to eq(company.legal_name)
        expect(first[:purchase][:product][:name]).to eq(product2.name)
        expect(first[:purchase][:pix_setting][:token]).to eq(purchase2.pix_setting.token)
        expect(first[:purchase][:boleto_setting]).to eq(nil)
        expect(first[:purchase][:credit_card_setting]).to eq(nil)
        expect(first[:purchase][:customer_payment_method][:token]).to eq(customer_payment_method.token)
        expect(parsed_body).to_not include(purchase.expiration_date.to_s)
        expect(parsed_body).to_not include(product.name)
        expect(parsed_body).to_not include(purchase.pix_setting.token)
        expect(parsed_body).to_not include(other_customer_payment_method.token)
      end
    end

    context 'with three query parameter' do
      it 'with all query parameter. And got successfully' do
        owner = create(:user, :complete_company_owner)
        company = owner.company
        company.accepted!

        product = create(
          :product,
          company: company,
          type_of: 'single',
          name: 'Vídeo de CS:GO'
        )

        product2 = create(
          :product,
          company: company,
          type_of: 'single',
          name: 'Vídeo de CS:GO - 5k'
        )

        product3 = create(
          :product,
          company: company,
          type_of: 'single',
          name: 'Vídeo de CS:GO - bgdew'
        )

        customer_payment_method = create(:customer_payment_method, :pix, company: company)
        customer_payment_method2 = create(:customer_payment_method, :credit_card, customer: customer_payment_method.customer,
                                                                                  company: company)
        other_customer_payment_method = create(:customer_payment_method, :pix, company: company)

        purchase = create(
          :purchase,
          customer_payment_method: other_customer_payment_method,
          product: product,
          company: company
        )

        purchase2 = create(
          :purchase,
          customer_payment_method: customer_payment_method,
          product: product2,
          company: company
        )

        purchase3 = create(
          :purchase,
          customer_payment_method: customer_payment_method2,
          product: product2,
          type_of: 'credit_card',
          pix_setting: nil,
          credit_card_setting: create(:credit_card_setting),
          company: company
        )

        get "/api/v1/purchases?customer_token=#{customer_payment_method.customer.token}&product_token=#{product2.token}&type=pix",
            headers: { companyToken: company.token }

        first = parsed_body.first

        expect(response).to have_http_status(200)
        expect(response.content_type).to include('application/json')
        expect(first[:purchase][:type_of]).to eq('pix')
        expect(first[:purchase][:cost]).to eq('9.99')
        expect(first[:purchase][:paid_date]).to eq(purchase.paid_date.to_s)
        expect(first[:purchase][:paid_date]).to eq(purchase.expiration_date.to_s)
        expect(first[:purchase][:company][:legal_name]).to eq(company.legal_name)
        expect(first[:purchase][:product][:name]).to eq(product2.name)
        expect(first[:purchase][:pix_setting][:token]).to eq(purchase2.pix_setting.token)
        expect(first[:purchase][:boleto_setting]).to eq(nil)
        expect(first[:purchase][:credit_card_setting]).to eq(nil)
        expect(first[:purchase][:customer_payment_method][:token]).to eq(customer_payment_method.token)
        expect(parsed_body).to_not include(purchase3.expiration_date.to_s)
        expect(parsed_body).to_not include(product.name)
        expect(parsed_body).to_not include(purchase3.credit_card_setting.token)
        expect(parsed_body).to_not include(customer_payment_method2.token)
      end
    end
  end

  context 'GET /api/v1/purchases/:token' do
    it 'sucessfuly' do
      owner = create(:user, :complete_company_owner)
      company = owner.company
      company.accepted!

      product = create(
        :product,
        company: company,
        type_of: 'single',
        name: 'Vídeo de CS:GO'
      )

      product2 = create(
        :product,
        company: company,
        type_of: 'single',
        name: 'Vídeo de CS:GO - 5k'
      )

      customer_payment_method = create(:customer_payment_method, :pix, company: company)

      purchase = create(
        :purchase,
        customer_payment_method: customer_payment_method,
        product: product,
        company: company
      )

      purchase2 = create(
        :purchase,
        customer_payment_method: customer_payment_method,
        product: product2,
        company: company
      )

      get "/api/v1/purchases/#{purchase.token}", headers: { companyToken: company.token }
      json = parsed_body[:purchase]
      expect(response).to have_http_status(200)
      expect(response.content_type).to include('application/json')
      expect(json[:type_of]).to eq('pix')
      expect(json[:cost]).to eq('9.99')
      expect(json[:paid_date]).to eq(purchase.paid_date.to_s)
      expect(json[:paid_date]).to eq(purchase.expiration_date.to_s)
      expect(json[:company][:legal_name]).to eq(company.legal_name)
      expect(json[:product][:name]).to eq(product.name)
      expect(json[:pix_setting][:token]).to eq(purchase.pix_setting.token)
      expect(json[:boleto_setting]).to eq(nil)
      expect(json[:credit_card_setting]).to eq(nil)
      expect(json[:customer_payment_method][:token]).to eq(customer_payment_method.token)
      expect(parsed_body).to_not include(purchase2.pix_setting.token)
      expect(parsed_body).to_not include(purchase2.product.name)
    end
  end
end
