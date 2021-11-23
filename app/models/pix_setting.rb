class PixSetting < ApplicationRecord
  belongs_to :company
  belongs_to :payment_method, -> { where(type_of: :pix) }, inverse_of: :pix_settings

  validates :pix_key, :bank_code, presence: true
  validates :bank_code, bank_code: true
end
