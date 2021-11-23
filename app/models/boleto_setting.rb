class BoletoSetting < ApplicationRecord
  belongs_to :company
  belongs_to :payment_method, -> { where(type_of: :boleto) }, inverse_of: :boleto_settings

  validates :agency_number, :account_number, :bank_code, presence: true
  validates :bank_code, bank_code: true
end
