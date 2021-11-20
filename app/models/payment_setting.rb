class PaymentSetting < ApplicationRecord
  belongs_to :company
  belongs_to :payment_method

  # before_validate, se o type_of do payment_method passado for pix, self.type = pix
  before_validation :config_type

  private
  def config_type
    self.type = payment_method.type_of
  end
end
