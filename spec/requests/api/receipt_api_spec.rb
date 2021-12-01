require 'rails_helper'

# data de vencimento da
# cobrança, a data efetiva do pagamento e um código de autorização
describe 'Receipt Api' do
  context 'GET /api/v1/receipt' do
    it 'company should view all company receipts' do
      receipt = create(:receipt)
      company = receipt.purchase.company

      get '/api/v1/receipt/', headers: { companyToken: company.token }

      expect(response).to have_http_status(200)
      purchase = parsed_body[:receipt][:purchase]
      expect(purchase[:expiration_date])
      expect(purchase[:paid_date])
      expect(parsed_body[:receipt][:authorization_code])
    end

    it 'and receive empty response' do
      get '/api/v1/receipt/', headers: { companyToken: company.token }

      expect(response).to have_http_status(200)
      expect(parsed_body).to be_empty
    end

    it '500 server error' do
      receipt = create(:receipt)
      company = receipt.purchase.company

      allow(Receipt).to receive(:find_by).and_raise(ActiveRecord::ActiveRecordError)
      get '/api/v1/receipt/', headers: { companyToken: company.token }

      expect(response).to have_http_status(500)
      expect(parsed_body[:message]).to eq('Erro geral')
    end
  end

  context 'GET /api/v1/receipt/:id' do
    # TODO: como identificar o receipt? (token, código de autorização, etc)
    it 'visitor should view one receipt' do
      receipt = create(:receipt)

      get "/api/v1/receipt/#{receipt[:authorization_code]}"

      expect(response).to have_http_status(200)
      purchase = parsed_body[:receipt][:purchase]
      expect(purchase[:expiration_date])
      expect(purchase[:paid_date])
      expect(parsed_body[:receipt][:authorization_code])
    end

    it '404 not found' do
      get '/api/v1/receipt/uy2387rg23h'

      expect(response).to have_http_status(404)
      expect(parsed_body[:message]).to eq('Objeto não encontrado')
    end

    it '500 server error' do
      receipt = create(:receipt)
      company = receipt.purchase.company

      allow(Receipt).to receive(:find_by).and_raise(ActiveRecord::ActiveRecordError)
      get '/api/v1/receipt/', headers: { companyToken: company.token }

      expect(response).to have_http_status(500)
      expect(parsed_body[:message]).to eq('Erro geral')
    end
  end
end
