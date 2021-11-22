require 'rails_helper'

describe 'Sombody try access when is not authenticated' do
  it 'and cannot open form to create a payment_method' do
    get '/admin/payment_methods/new'

    expect(response).not_to redirect_to(admin_payment_methods_path)
    expect(response).to redirect_to(root_path)
  end
  it 'and cannot create a payment_method' do
    post '/admin/payment_methods'

    expect(response).not_to redirect_to(admin_payment_methods_path)
    expect(response).to redirect_to(root_path)
  end
end
