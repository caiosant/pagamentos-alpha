require 'rails_helper'

describe 'Authenticated User try access restrict adimin area' do
  it 'and cannot open form to create a payment_method' do
    user = create(:user)

    login_as user, scope: :user

    get '/payment_methods/new'

    expect(response).not_to redirect_to(payment_methods_path)
  end
  it 'and cannot create a payment_method' do
    user = create(:user)

    login_as user, scope: :user

    post '/payment_methods'

    expect(response).not_to redirect_to(payment_methods_path)
  end
end
