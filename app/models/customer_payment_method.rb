class CustomerPaymentMethod < ApplicationRecord
  belongs_to :payment_method
  belongs_to :company
  belongs_to :customer

  after_create :generate_token_attribute
end
