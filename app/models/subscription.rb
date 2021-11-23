class Subscription < ApplicationRecord
  belongs_to :company

  enum status: { enabled: 5, disabled: 10 }
end
