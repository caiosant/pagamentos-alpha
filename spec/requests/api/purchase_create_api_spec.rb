require 'rails_helper'

describe 'Transaction can be created on POST /api/v1/purchases'  do
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
            bank_code: "001"
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
            bank_code: "001"
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