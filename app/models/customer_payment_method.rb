class CustomerPaymentMethod < ApplicationRecord
  belongs_to :payment_method
  belongs_to :company
  belongs_to :customer

  after_create :generate_token_attribute

  # TODO: validar expiration date
  validates :credit_card_name, :credit_card_number, :credit_card_expiration_date,
    :credit_card_security_code, presence: true, if: -> { payment_method.credit_card? }

  def add_credit_card(params)
    return unless payment_method.credit_card?

    self.credit_card_name = params[:credit_card_name]
    self.credit_card_number = params[:credit_card_number]
    self.credit_card_expiration_date = params[:credit_card_expiration_date]
    self.credit_card_security_code = params[:credit_card_security_code]
  end
end
