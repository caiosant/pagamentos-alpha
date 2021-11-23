require 'rails_helper'

# recebe cpf, meio de pagamento, numero do cartão + validade (só cartão)
# retorna token do cliente
describe Api::V1::CustomerController, type: :controller do
  context 'POST #create' do
    subject { post :create, params: { cpf: '111.111.111-11', payment_method_id: 1 } }

    context 'successfully' do
      it 'with pix' do
        # post '/create'
        # byebug
        expect(response).to have_http_status(200)
        expect(response.body).to eq('LI5YuUJrZuJSB6uPH2jm')
      end

      xit 'with boleto' do
        expect(response).to have_http_status(200)
        expect(parsed_body.token).to eq('LI5YuUJrZuJSB6uPH2jm')
      end

      it 'with credit card' do
      end
    end

    context 'with error' do
      it 'should inform credit card data'

      it 'should inform cpf'

      it 'should inform payment_method_id'

      it 'payment_method does not exist'
    end
  end
end
