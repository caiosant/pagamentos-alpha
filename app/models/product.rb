class Product < ApplicationRecord
  belongs_to :company

  enum status: { enabled: 5, disabled: 10 }

  validates :name, presence: true

  after_create :generate_token_attribute

  def generate_token_attribute
    self.token = generate_token
    save!
  end
end
