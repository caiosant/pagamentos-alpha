class PixSetting < ApplicationRecord
  belongs_to :company
  belongs_to :payment_method

  validates :pix_key, :bank_code, presence: true
  validates :bank_code, bank_code: true
end
