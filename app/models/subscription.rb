class Subscription < ApplicationRecord
  belongs_to :company

  enum status: { enabled: 5, disabled: 10 }

  after_create :generate_token_attribute

  def generate_token_attribute
    self.token = generate_token
    save!
  end
end
