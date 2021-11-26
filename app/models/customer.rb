class Customer < ApplicationRecord
  belongs_to :company

  after_create :generate_token_attribute

  validates :name, presence: true
  validates :cpf, presence: true
end
