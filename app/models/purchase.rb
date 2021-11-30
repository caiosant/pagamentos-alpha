class Purchase < ApplicationRecord
  belongs_to :customer_payment_method
  belongs_to :pix_setting, optional: true
  belongs_to :boleto_setting, optional: true
  belongs_to :credit_card_setting, optional: true
  belongs_to :product
  belongs_to :company
  has_one :receipt, optional: true
  enum type_of: { pix: 0, boleto: 5, credit_card: 10}

  def validate_product_is_not_subscription

  end
end
