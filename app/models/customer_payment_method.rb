class CustomerPaymentMethod < ApplicationRecord
  belongs_to :payment_method
  belongs_to :company
  belongs_to :customer

  after_create :generate_token_attribute

  validates :credit_card_name, :credit_card_number, :credit_card_expiration_date,
            :credit_card_security_code, presence: true, if: -> { payment_method&.credit_card? }

  validate :expiration_date_cannot_be_in_the_past, if: -> { payment_method&.credit_card? }

  enum name: { pix: 5, boleto: 10, cartao_de_credito: 15 }

  # TODO: testar esse metodo?
  def add_credit_card(params)
    return unless payment_method&.credit_card?

    self.credit_card_name = params[:credit_card_name]
    self.credit_card_number = params[:credit_card_number]
    self.credit_card_expiration_date = params[:credit_card_expiration_date]
    self.credit_card_security_code = params[:credit_card_security_code]
  end

  private

  def expiration_date_cannot_be_in_the_past
    return unless credit_card_expiration_date.present? && credit_card_expiration_date < Time.zone.today

    errors.add(:credit_card_name, 'inválido(a)')
    errors.add(:credit_card_number, 'inválido(a)')
    errors.add(:credit_card_expiration_date, 'inválido(a)')
    errors.add(:credit_card_security_code, 'inválido(a)')
  end
end
