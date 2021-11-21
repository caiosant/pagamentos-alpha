class CreditCardSetting < ApplicationRecord
  belongs_to :company
  belongs_to :payment_method
end
