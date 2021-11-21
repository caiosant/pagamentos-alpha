class Company < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :pix_settings
  has_many :credit_card_settings
  has_many :boleto_settings

  enum status: { incomplete: 0, pending: 10, accepted: 20, rejected: 30 }

  has_one :owner, -> { where owner: true },
          class_name: 'User', inverse_of: 'company', dependent: :destroy

  after_save :check_if_still_incomplete

  validates :cnpj, :legal_name, :billing_address, :billing_email,
            presence: true, on: :update
  validates :billing_email, private_email: true, on: :update
  validates :cnpj, cnpj: true, on: :update

  def payment_settings
    self.pix_settings + self.credit_card_settings + self.boleto_settings
  end

  private

  def any_essential_info_blank?
    [cnpj, legal_name, billing_address, billing_email].all?(&:blank?)
  end

  def check_if_still_incomplete
    pending! if !any_essential_info_blank? && incomplete?
  end
end
