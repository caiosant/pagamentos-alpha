require 'rails_helper'

describe 'company can be updated' do
  it 'if user is the company owner' do
    owner = create(:user, owner: true)

    login_as owner, scope: :user
    put company_path owner.company,
    params: { company: { 
        cnpj: '12.123.123/0001-12', 
        legal_name: 'Empresa numero 1',
        billing_address: 'Endereço cidade tal rua tal etc',
        billing_email: 'faturamento@companymail.com',
        } 
    }

    expect(response).to redirect_to company_path owner.company
  end

  it 'unless user is linked to the company but isnt owner' do
    owner = create(:user, owner: true)
    user = create(:user, owner: false, company: owner.company)

    login_as user, scope: :user
    put company_path owner.company,
    params: { company: { 
        cnpj: '12.123.123/0001-12', 
        legal_name: 'Empresa numero 1',
        billing_address: 'Endereço cidade tal rua tal etc',
        billing_email: 'faturamento@companymail.com',
        } 
    }

    expect(response).to redirect_to(root_path)
    expect(flash[:alert]).to eq('Você não tem permissão para alterar os dados '\
      'dessa empresa.')
  end

  it 'unless user is from another company' do
    owner = create(:user, owner: true)

    owner2 = create(:user, owner: true)
    user = create(:user, owner: false, company: owner2.company)

    login_as user, scope: :user
    put company_path owner.company,
    params: { company: { 
        cnpj: '12.123.123/0001-12', 
        legal_name: 'Empresa numero 1',
        billing_address: 'Endereço cidade tal rua tal etc',
        billing_email: 'faturamento@companymail.com',
        } 
    }

    expect(response).to redirect_to(root_path)
    expect(flash[:alert]).to eq('Você não tem permissão para alterar os dados '\
      'dessa empresa.')
  end

  it 'unless visitor is not signed in' do
    owner = create(:user, owner: true)

    put company_path owner.company,
    params: { company: { 
        cnpj: '12.123.123/0001-12', 
        legal_name: 'Empresa numero 1',
        billing_address: 'Endereço cidade tal rua tal etc',
        billing_email: 'faturamento@companymail.com',
        } 
    }

    expect(response).to redirect_to(new_user_session_path)
  end

  xit 'unless user is an admin' do
    # TODO: Esse fica pra quando tiver o admin pronto
  end
end
