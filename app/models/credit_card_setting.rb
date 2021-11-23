class CreditCardSetting < ApplicationRecord
  belongs_to :company
  belongs_to :payment_method, -> { where(type_of: :credit_card) }, inverse_of: :credit_card_settings

  validates :company_code, presence: true
end
