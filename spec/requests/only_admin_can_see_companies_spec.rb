require 'rails_helper'

describe 'companies can be seen only by admin' do
  it 'a user with no filed company try to access companies' do
    owner = create(:user, owner: true)

    login_as owner, scope: :user
    get companies_path

    expect(response).to redirect_to(edit_company_path(owner.company))
  end

  it 'a user with filed company try to access companies' do
    owner = create(:user, :complete_company_owner)

    login_as owner, scope: :user
    get companies_path

    expect(response).to redirect_to(root_path)
  end

  it 'a visitor try to access companies' do
    get companies_path

    expect(response).to redirect_to(root_path)
  end
end
