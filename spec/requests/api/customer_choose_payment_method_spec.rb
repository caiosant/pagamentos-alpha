require 'rails_helper'

# recebe token da empresa, cpf, meio de pagamento, 
# numero do cartão + validade (só cartão)
# retorna token do cliente
describe 'Customer API' do
  context 'POST /api/v1/customer' do

    context 'successfully' do
      it 'with pix' do
        owner = create(:user, :complete_company_owner)
        owner.company.accepted!
        pix_method = create(:payment_method, :pix)
        pix_setting = create(:pix_setting, company: owner.company, payment_method: pix_method)
        company_payment_method = pix_setting.payment_method

        post '/api/v1/customer'

        expect(response).to have_http_status(200)
        expect(parsed_body[:token]).to eq('LI5YuUJrZuJSB6uPH2jm')
      end

      it 'with boleto' do
        expect(response).to have_http_status(200)
        expect(parsed_body.token).to eq('LI5YuUJrZuJSB6uPH2jm')
      end

      it 'with credit card' do
      end
    end

    context 'with error' do
      it 'should inform credit card number'

      it 'should inform credit card expiration date'

      it 'should inform cpf'

      it 'should inform payment_method_id'

      it 'payment_method does not exist'

      it 'cannot create without company token'
    end

  end
end
