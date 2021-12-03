class Fraud < ApplicationRecord
  belongs_to :purchases

  has_one_attached :file
end
