class CreditCardSettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_user_company_accepted

  def new
    @payment_methods_dropdown = PaymentMethod.payment_methods_by_type_dropdown('credit_card')
    @credit_card_setting = CreditCardSetting.new
  end

  def create
    @payment_methods_dropdown = PaymentMethod.payment_methods_by_type_dropdown('credit_card')
    @credit_card_setting = CreditCardSetting.new(**credit_card_params, company: current_user.company)

    if @credit_card_setting.save
      redirect_to company_payment_settings_path(current_user.company), notice: t('payment_settings.created_notice')
    else
      render :new
    end
  end

  private

  def credit_card_params
    params.require(:credit_card_setting).permit(:company_code, :payment_method_id)
  end
end
