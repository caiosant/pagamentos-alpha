class PixSetting < ApplicationRecord
  belongs_to :company
  belongs_to :payment_method, -> { where(type_of: :pix) }, inverse_of: :pix_settings

  enum status: { enabled: 5, disabled: 10 }

  validates :pix_key, :bank_code, presence: true
  validates :bank_code, bank_code: true
  after_create :generate_token_attribute
end
