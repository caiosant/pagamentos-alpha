class Api::V1::CustomerController < Api::V1::ApiController
  def create
    render status: 200, json: {token: '73grr29y'}.as_json
  end

  private
  def customer_params
    params.require(:customer).permit(
      :company_token, :cpf, :payment_method_token, :credit_card_number, 
      :credit_card_expiration_date
    )
  end
end
