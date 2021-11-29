class CreditCardSetting < ApplicationRecord
  belongs_to :company
  belongs_to :payment_method, -> { where(type_of: :credit_card) }, inverse_of: :credit_card_settings

  enum status: { enabled: 5, disabled: 10 }

  validates :company_code, presence: true
  after_create :generate_token_attribute
end
