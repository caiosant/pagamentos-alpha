require 'rails_helper'

describe 'Product API' do
  context 'POST /api/v1/products' do
    it 'successfully' do
      owner = create(:user, :complete_company_owner)
      company = owner.company
      company.accepted!

      post '/api/v1/products', 
      params: {product:{name:'Video de LOL'}},
      headers: { companyToken: company.token }

      product = Product.last

      expect(response).to have_http_status(201)
      expect(parsed_body[:name]).to eq(product.name)
      expect(parsed_body[:token]).to eq(product.token)
    end

    it 'fail because name is blank' do
      owner = create(:user, :complete_company_owner)
      company = owner.company
      company.accepted!

      post '/api/v1/products', 
      params: {product:{name:''}},
      headers: { companyToken: company.token }
    
      expect(response).to have_http_status(422)
      expect(parsed_body[:errors][:name]).to eq(["não pode ficar em branco"])
    end
  end
  context 'GET /api/v1/products' do
    it 'should get all correspondig products' do
    end

    it 'return no product' do

    end
  end
  context 'GET /api/v1/products/:token' do
    it 'should get correspondig product' do
    end

    it 'should return 404 if product does not exist' do
    end
  end

  context 'POST /api/v1/products/:token/disable' do
    it 'successfully' do
    end

    it 'should return 404 if product does not exist' do
    end
  end

  context 'POST /api/v1/products/:token/enaable' do
    it 'successfully' do
    end

    it 'should return 404 if product does not exist' do
    end
  end
end