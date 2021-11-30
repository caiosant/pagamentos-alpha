require 'rails_helper'

describe 'Purchase API'  do
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
    
            pix_setting = create(
                :pix_setting,
                company: company,
                pix_key: '90803452a',
                bank_code: "001"
            )

            customer_payment_method = create(:customer_payment_method, :pix)

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

            get '/api/v1/customer', headers: { companyToken: company.token }

            first = parsed_body[:purchase].first
            second = parsed_body[:purchase].second

            expect(response).to have_http_status(200)
            expect(response.content_type).to include('application/json')
            expect(first[:type_of]).to eq('pix')
            expect(first[:cost]).to eq('9.99')
            expect(first[:paid_date]).to eq(purchase.paid_date)
            expect(first[:paid_date]).to eq(purchase.expiration_date)
            expect(first[:company][:legal_name]).to eq(company.legal_name)
            expect(first[:product][:name]).to eq(product.name)
            expect(first[:pix_setting][:token]).to eq(pix_setting.token)
            expect(first[:boleto_setting][:token]).to eq("")
            expect(first[:credit_card_setting][:token]).to eq("")
            expect(first[:customer_payment_method][:token]).to eq(customer_payment_method.token)
            expect(second[:type_of]).to eq('pix')
            expect(second[:cost]).to eq('9.99')
            expect(second[:paid_date]).to eq(purchase2.paid_date)
            expect(second[:paid_date]).to eq(purchase2.expiration_date)
            expect(second[:company][:legal_name]).to eq(company.legal_name)
            expect(second[:product][:name]).to eq(product2.name)
            expect(second[:pix_setting][:token]).to eq(pix_setting.token)
            expect(second[:boleto_setting][:token]).to eq("")
            expect(second[:credit_card_setting][:token]).to eq("")
            expect(second[:customer_payment_method][:token]).to eq(customer_payment_method.token)
        end
    end
end