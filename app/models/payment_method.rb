class PaymentMethod < ApplicationRecord
  has_one_attached :icon

  validates :name, :fee, :maximum_fee, :icon, presence: true
end
