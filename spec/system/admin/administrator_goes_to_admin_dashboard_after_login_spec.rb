require 'rails_helper'

describe 'try to access the system' do
  it 'unsuccessfully' do
    visit admin_dashboard_path

    expect(page).to have_content('Para continuar, efetue login ou registre-se.')
  end
end
