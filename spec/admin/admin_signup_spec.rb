require 'rails_helper'

describe 'adminstrator of system create a account' do
  it 'successfuly' do
    visit new_admin_registration_path

    fill_in 'email', with: 'admin@pagapaga.com.br'
    fill_in 'password', with: '123456' 

    click_on 'Sign up'
  end
end