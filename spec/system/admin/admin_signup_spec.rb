require 'rails_helper'

describe 'adminstrator try to create a account' do
  it 'and do it successfuly' do
    visit new_admin_registration_path

    fill_in 'Email', with: 'admin@pagapaga.com.br'
    fill_in 'Senha', with: '123456'
    fill_in 'Confirmação da Senha', with: '123456'

    click_on 'Cadastrar'
  end

  it 'and try to register with a personal e-mail' do
    visit new_admin_registration_path

    fill_in 'Email', with: 'admin@hotmail.com'
    fill_in 'Senha', with: '123456'
    fill_in 'Confirmação da Senha', with: '123456'
    click_on 'Cadastrar'

    expect(page).to have_content('Este e-mail não é válido')
  end

  it 'and leave the email empty' do
    visit new_admin_registration_path

    fill_in 'Email', with: ''
    fill_in 'Senha', with: '123456'
    fill_in 'Confirmação da Senha', with: '123456'
    click_on 'Cadastrar'

    expect(page).to have_content('Email não pode ficar em branco')
  end

  it 'and the password is shorter' do
    visit new_admin_registration_path

    fill_in 'Email', with: 'admin@pagapaga.com.br'
    fill_in 'Senha', with: '123'
    fill_in 'Confirmação da Senha', with: '123'
    click_on 'Cadastrar'

    expect(page).to have_content('Senha é muito curto (mínimo: 6 caracteres)')
  end

  it 'and try to use a already registred email' do
    admin = create(:admin)

    visit new_admin_registration_path

    fill_in 'Email', with: admin.email
    fill_in 'Senha', with: '123456'
    fill_in 'Confirmação da Senha', with: '123456'
    click_on 'Cadastrar'

    expect(page).to have_content("Email #{admin.email} já está em uso")
  end

  it 'and recives a confirmation email' do
    visit new_admin_registration_path

    fill_in 'Email', with: 'admin@pagapaga.com.br'
    fill_in 'Senha', with: '123456'
    fill_in 'Confirmação da Senha', with: '123456'
    click_on 'Cadastrar'

    mail = Devise.mailer.deliveries.first

    expect(Devise.mailer.deliveries.count).to eq 1
    expect(mail.from.first).to eq 'confirmacao@pagapaga.com.br'
    expect(mail.to.first).to eq 'admin@pagapaga.com.br'
    expect(mail.subject).to eq 'Instruções de confirmação'
  end

  it "and can't login without confirm his email" do
    admin = create(:admin)

    visit new_admin_session_path

    fill_in 'Email', with: admin.email
    fill_in 'Senha', with: admin.password
    within 'form' do
      click_on 'Entrar'
    end

    expect(page).to have_content('Antes de continuar, confirme a sua conta.')
  end
end
