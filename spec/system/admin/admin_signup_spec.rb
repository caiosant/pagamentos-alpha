require 'rails_helper'

describe 'adminstrator of system create a account' do
  it 'successfuly' do
    visit new_admin_registration_path

    fill_in 'Email', with: 'admin@pagapaga.com.br'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'

    click_on 'Sign up'
  end

  it 'try to register with a personal e-mail' do
    visit new_admin_registration_path

    fill_in 'Email', with: 'admin@gmail.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_on 'Sign up'

    expect(page).to have_content('Este e-mail não é válido')
  end
end