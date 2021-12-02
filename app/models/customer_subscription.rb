class CustomerSubscription < ApplicationRecord
  belongs_to :product
  belongs_to :customer_payment_method
  belongs_to :company

  enum status: { active: 0, pending: 5, canceled: 10 }

  # TODO: adicionar validação de numericality 1-28 pra renovation_date
  before_validation :create_renovation_date
  after_create :generate_token_attribute

  validates :cost, presence: true

  def self.renew_subscriptions
    today = Time.zone.today
    today_subscriptions = CustomerSubscription.where(renovation_date: today.day)

    today_subscriptions.each do |s|
      Purchase.create(
        company: s.company, customer_payment_method: s.customer_payment_method,
        product: s.product, cost: s.cost, expiration_date: today
      )
    end
  end

  def validate_product_is_not_single
    return unless self.product&.single?
    self.errors.add :product, 'sua assinatura precisa ser vinculada com um product do tipo subscription'
  end

  private

  def create_renovation_date
    today = Time.zone.today

    # TODO: colocar em um metodo pela legibilidade
    if today.day > 28
      self.renovation_date = 1
    else
      self.renovation_date = today.day
    end
  end
end
