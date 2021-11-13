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
end
