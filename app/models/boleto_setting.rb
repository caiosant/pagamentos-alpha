class BoletoSetting < ApplicationRecord
  belongs_to :company
  belongs_to :payment_method

  validates :agency_number, :account_number, :bank_code, presence: true
end
