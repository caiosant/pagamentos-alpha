class Api::V1::CustomerPaymentMethodController < Api::V1::ApiController
  def create
    @payment_method = find_payment_method
    @customer = Customer.find_by(token: customer_payment_method_params[:customer_token])

    @customer_payment_method = CustomerPaymentMethod.new(
      payment_method: @payment_method,
      customer: @customer,
      company: @company
    )
    @customer_payment_method.add_credit_card(credit_card_params) if @payment_method.credit_card?

    return render status: 201, json: success_json if @customer_payment_method.save

    render status: 422, json: error_json
  end

  private
  def customer_payment_method_params
    params.require(:customer_payment_method).permit(:customer_token, :payment_method_token)
  end

  def credit_card_params
    params.require(:customer_payment_method).permit(
      :credit_card_name, :credit_card_number,
      :credit_card_expiration_date, :credit_card_security_code
    )
  end

  def find_payment_method
    payment_setting = @company.payment_settings.find{ |ps|
      ps.token == customer_payment_method_params[:payment_method_token]
    }
    payment_setting.payment_method
  end

  def success_json
    @customer_payment_method.as_json(
      only: %i[token],
      include: {
        payment_method: { only: %i[name type_of] },
        customer: { only: %i[token] },
        company: { only: %i[legal_name] }
      }
    )
  end

  def error_json
    {
      message: 'Requisição inválida',
      errors:  @customer_payment_method.errors,
      # TODO: passar entrada do cartão de crédito de volta?
      request: @customer_payment_method.as_json(
        # except: %i[
        #   id created_at updated_at token company_id customer_id payment_method_id
        #   credit_card_name credit_card_number credit_card_expiration_date credit_card_security_code
        # ],
        only: %i[],
        include: {
          payment_method: { only: %i[name type_of] },
          customer: { only: %i[token] },
          company: { only: %i[legal_name] }
        }
      )
    }
  end
end
