class Transaction < ApplicationRecord
  belongs_to :customer_payment_method
  belongs_to :pix_setting
  belongs_to :boleto_setting
  belongs_to :credit_card_setting
  belongs_to :product
  belongs_to :receipt
  enum type_of: { pix: 0, boleto: 5, credit_card: 10}
end
