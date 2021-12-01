class Receipt < ApplicationRecord
  belongs_to :purchase, optional: true
end
