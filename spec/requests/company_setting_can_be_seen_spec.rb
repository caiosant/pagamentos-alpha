describe 'company setting can be created' do
    it 'unless company is not approved' do
        owner = create(:user, :complete_company_owner)
    
        login_as owner, scope: :user
        get company_payment_settings_path owner.company
    
        expect(response).to redirect_to(company_path owner.company)
        expect(flash[:alert]).to eq('Esta empresa ainda não foi aprovada')
    end
end