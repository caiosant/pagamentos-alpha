class Api::V1::CustomerController < Api::V1::ApiController
  def create
    byebug
    render status: 200, json: PaymentMethod.first
  end
end
