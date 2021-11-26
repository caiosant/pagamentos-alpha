class Api::V1::CustomerPaymentMethodController < Api::V1::ApiController
  def create
    payment_settings = @company.payment_settings.find{|ps|
      ps.token == customer_payment_method_params[:payment_method_token]
    }
    @payment_method = payment_settings.payment_method
    @customer = Customer.find_by(token: customer_payment_method_params[:customer_token])
    @customer_payment_method = CustomerPaymentMethod.new(payment_method: @payment_method,
                                                          customer: @customer,
                                                          company: @company)
    
    if @customer_payment_method.save
      render status: 201, json: @customer_payment_method.as_json(
        only: %i[token],
        include: {
          payment_method: { only: %i[name type_of] },
          customer: { only: %i[token] },
          company: { only: %i[legal_name] }
        }
      )
    else
      render status: 422, json: { message: 'Requisição inválida',
                                  errors:  @customer_payment_method.errors ,
                                  request: @customer_payment_method.as_json(except: %i[id token company_id 
                                                                        created_at updated_at])
                                }    
    end
  end

  private
  def customer_payment_method_params
    params.require(:customer_payment_method).permit(:customer_token, :payment_method_token)
  end
end
