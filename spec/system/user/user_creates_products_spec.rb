require 'rails_helper'

describe 'authenticated user creates a new product' do
  it 'must be signed in' do
    visit products_path

    expect(page).to have_content('Para continuar, efetue login ou registre-se.')
  end

  it 'successfully' do
    owner = create(:user, :complete_company_owner)
    owner.company.accepted!

    login_as owner, scope: :user
    visit company_path(owner.company)
    click_on 'Criar produto'

    fill_in 'Nome', with: 'Playlist Minecraft'
    
    expect(page).to have_content('Nome: Playlist Minecraft')
  end
end
