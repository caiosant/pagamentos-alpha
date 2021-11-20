class PaymentSetting < ApplicationRecord
  belongs_to :company
  belongs_to :payment_method

  before_validation :config_type

  private
  def config_type
    self.type = "#{payment_method.type_of.camelize}Setting"
  end
end
