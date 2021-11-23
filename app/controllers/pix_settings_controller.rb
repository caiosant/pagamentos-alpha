class PixSettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_user_company_accepted

  def new
    @payment_methods_dropdown = PaymentMethod.payment_methods_by_type_dropdown('pix')
    @pix_setting = PixSetting.new
  end

  def create
    @payment_methods_dropdown = PaymentMethod.payment_methods_by_type_dropdown('pix')
    @pix_setting = PixSetting.new(**pix_params, company: current_user.company)
    @payment_methods_dropdown = PaymentMethod.payment_methods_by_type_dropdown('pix')

    if @pix_setting.save
      redirect_to company_payment_settings_path(current_user.company), notice: t('payment_settings.created_notice')
    else
      render :new
    end
  end

  private

  def pix_params
    params.require(:pix_setting).permit(:pix_key, :bank_code, :payment_method_id)
  end
end
