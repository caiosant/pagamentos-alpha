class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def generate_token(size = 20)
    SecureRandom.alphanumeric(size)
  end
end
