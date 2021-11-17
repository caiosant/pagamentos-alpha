require 'rails_helper'

describe 'Sombody try access when is not authenticated' do
  it 'and cannot open form to create a payment_method' do
    get '/payment_methods/new'

    expect(response).not_to redirect_to(payment_methods_path)
  end
  it 'and cannot create a payment_method' do
    post '/payment_methods'

    expect(response).not_to redirect_to(payment_methods_path)
  end
end
