class Api::V1::ReceiptsController < Api::V1::ApiController
  def index
    # TODO: deve ter um jeito melhor de fazer isso
    customer_payment_methods = CustomerPaymentMethod.where(company: @company)
    purchases = Purchase.where(customer_payment_method: customer_payment_methods)
    @receipts = Receipt.where(purchase: purchases)

    render status: 200, json: @receipts.as_json(
      only: %i[token authorization_code],
      include: {
        purchase: {
          only: %i[expiration_date paid_date type_of],
          include: {
            product: { only: %i[name token] },
            company: { only: %i[legal_name] }
          }
        }
      } 
    )
  end
end
