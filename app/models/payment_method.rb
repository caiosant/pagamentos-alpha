class PaymentMethod < ApplicationRecord
  has_one_attached :icon
  enum status: { enabled: 5, disabled: 10 }

  validates :name, :fee, :maximum_fee, :icon, presence: true

  def self.query_for_enabled
    PaymentMethod.where(status: :enabled)
  end
end
