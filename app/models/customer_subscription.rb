class CustomerSubscription < ApplicationRecord
  belongs_to :product
  belongs_to :customer_payment_method
  belongs_to :company

  enum status: { active: 0, pending: 5, canceled: 10 }

  before_validation :create_renovation_date
  after_create :generate_token_attribute

  validates :cost, presence: true

  def validate_product_is_not_single
    return unless self.product&.single?
    self.errors.add :product, 'sua assinatura precisa ser vinculada com um product do tipo subscription'
  end

  private

  def create_renovation_date
    today = Time.zone.today

    # TODO: colocar em um metodo pela legibilidade
    if today.day > 28
      new_date = (today + 1.month).change(day: 1)
      self.renovation_date = new_date
    else
      self.renovation_date = today
    end
  end
end
