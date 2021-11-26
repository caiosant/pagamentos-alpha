require 'rails_helper'

describe 'Visitor tries to change payment settings statuses' do
    context 'pix_setting' do
        it 'but fails on disabling and gets redirected' do
            owner = create(:user, :complete_company_owner)
            company = owner.company
            company.accepted!
            pix_setting = create(:pix_setting, company: company)

            post disable_pix_setting_path pix_setting

            expect(response).to redirect_to(new_user_session_path)
            expect(flash[:alert]).to eq('Para continuar, efetue login ou registre-se.')  
        end

        it 'but fails on enabling and gets redirected' do
            owner = create(:user, :complete_company_owner)
            company = owner.company
            company.accepted!
            pix_setting = create(:pix_setting, company: company)
            pix_setting.disabled!

            post enable_pix_setting_path pix_setting

            expect(response).to redirect_to(new_user_session_path)
            expect(flash[:alert]).to eq('Para continuar, efetue login ou registre-se.') 
        end

        it 'but fails on disabling(user from another company)' do
            owner = create(:user, :complete_company_owner)
            company = owner.company
            company.accepted!
            pix_setting = create(:pix_setting, company: company)

            owner2 = create(:user, :complete_company_owner)
            company2 = owner2.company
            company2.accepted!

            login_as owner2, scope: :user
            post disable_pix_setting_path pix_setting

            expect(response).to redirect_to(root_path)
            expect(flash[:alert]).to eq('Você não tem permissão para ver os dados dessa empresa.')  
        end
    end

    context 'boleto_setting' do
        it 'but fails on disabling and gets redirected'
        it 'but fails on enabling and gets redirected'
    end

    context 'credit_card_setting' do
        it 'but fails on disabling and gets redirected'
        it 'but fails on enabling and gets redirected'
    end
end