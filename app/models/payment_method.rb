class PaymentMethod < ApplicationRecord
  has_one_attached :icon
  enum status: { enabled: 5, disabled: 10 }

  validates :name, :fee, :maximum_fee, :icon, presence: true
end
