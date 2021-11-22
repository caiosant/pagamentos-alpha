class PixSettingsController < ApplicationController
  def new
    @payment_methods_dropdown = PaymentMethod.payment_methods_by_type_dropdown('pix')
    @pix_setting = PixSetting.new
  end

  def create
  end
end
