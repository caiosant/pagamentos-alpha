class Api::V1::CustomerController < Api::V1::ApiController
  def create
    @customer = Customer.new(customer_params)

    if @customer.save
      render status: 200, json: { customer_token: @customer.token }.as_json
    else
      # TODO
    end
  end

  private
  def customer_params
    params.require(:customer).permit(:company_token, :cpf, :payment_method_token)
  end
end
