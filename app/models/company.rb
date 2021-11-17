class Company < ApplicationRecord
  has_many :users, dependent: :destroy

  enum status: { incomplete: 0, pending: 10, accepted: 20, rejected: 30 }

  has_one :owner, -> { where owner: true },
          class_name: 'User', inverse_of: 'company', dependent: :destroy

  after_create :check_if_still_incomplete
  after_update :check_if_still_incomplete

  validates :cnpj, :legal_name, :billing_address, :billing_email,
            presence: true, on: :update
  validates :billing_email, private_email: true, on: :update
  validates :cnpj, cnpj: true, on: :update

  private

  def any_essential_info_blank?
    [cnpj, legal_name, billing_address, billing_email].each do |info|
      return true if info.blank?
    end
    false
  end

  def check_if_still_incomplete
    pending! if !any_essential_info_blank? && incomplete?
  end
end
