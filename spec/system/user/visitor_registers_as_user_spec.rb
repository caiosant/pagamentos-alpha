require 'rails_helper'

describe 'Visitor registers as user' do
  it 'successfully' do
    visit root_path
    click_on 'Registrar como usuário'

    fill_in 'user_email', with: 'test@company.com'
    fill_in 'user_password', with: '123456789'
    fill_in 'user_password_confirmation', with: '123456789'
    click_on 'commit'

    expect(page).to have_content('Welcome! You have signed up successfully.')
  end

  it 'and fails when using a public email domain' do
    visit root_path
    click_on 'Registrar como usuário'

    fill_in 'user_email', with: 'test@gmail.com'
    fill_in 'user_password', with: '123456789'
    fill_in 'user_password_confirmation', with: '123456789'
    click_on 'commit'

    expect(page).to have_content('Email não pode ser um email de domínio público')
  end
end
