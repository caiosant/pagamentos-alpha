class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def generate_token(size = 20)
    SecureRandom.alphanumeric(size)
  end

  def generate_token_attribute
    self.token = generate_token
    save!
  end
end
