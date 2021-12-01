require 'rails_helper'

# data de vencimento da
# cobrança, a data efetiva do pagamento e um código de autorização
describe 'Receipt Api' do
  context 'GET /api/v1/receipts' do
    xit 'company should view all company receipts' do
      owner = create(:user, :complete_company_owner)
      owner.company.accepted!
      company = owner.company
      customer_payment_method = create(:customer_payment_method, :pix, company: company)
      product = create(:product)
      purchase = create(
        :purchase, company: company, customer_payment_method: customer_payment_method,
                   product: product
      )
      receipt = create(:receipt, purchase: purchase)

      get '/api/v1/receipts/', headers: { companyToken: company.token }

      expect(response).to have_http_status(200)
      purchase = parsed_body[:receipt][:purchase]
      expect(purchase[:expiration_date]).to eq(purchase.expiration_date)
      expect(purchase[:paid_date]).to eq(purchase.paid_date)
      expect(parsed_body[:receipt][:authorization_code]).to be_present
    end

    xit 'and receive empty response' do
      get '/api/v1/receipts/', headers: { companyToken: company.token }

      expect(response).to have_http_status(200)
      expect(parsed_body).to be_empty
    end

    xit '500 server error' do
      receipt = create(:receipt)
      company = receipt.purchase.company

      allow(Receipt).to receive(:find_by).and_raise(ActiveRecord::ActiveRecordError)
      get '/api/v1/receipts/', headers: { companyToken: company.token }

      expect(response).to have_http_status(500)
      expect(parsed_body[:message]).to eq('Erro geral')
    end
  end

  context 'GET /api/v1/receipt/:id' do
    # TODO: como identificar o receipt? (token, código de autorização, etc)
    xit 'visitor should view one receipt' do
      receipt = create(:receipt)

      get "/api/v1/receipt/#{receipt[:authorization_code]}"

      expect(response).to have_http_status(200)
      purchase = parsed_body[:receipt][:purchase]
      expect(purchase[:expiration_date]).to eq(purchase.expiration_date)
      expect(purchase[:paid_date]).to eq(purchase.paid_date)
      expect(parsed_body[:receipt][:authorization_code]).to be_present
    end

    xit '404 not found' do
      get '/api/v1/receipt/uy2387rg23h'

      expect(response).to have_http_status(404)
      expect(parsed_body[:message]).to eq('Objeto não encontrado')
    end

    xit '500 server error' do
      receipt = create(:receipt)
      company = receipt.purchase.company

      allow(Receipt).to receive(:find_by).and_raise(ActiveRecord::ActiveRecordError)
      get "/api/v1/receipt/#{receipt[:authorization_code]}"

      expect(response).to have_http_status(500)
      expect(parsed_body[:message]).to eq('Erro geral')
    end
  end
end
