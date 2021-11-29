module Api
  module V1
    class CustomerPaymentMethodController < Api::V1::ApiController
      def index
        @customer_payment_method = CustomerPaymentMethod.where(company: @company)

        render status: :ok, json: success_json
      end

      def show
        @customer_payment_method = CustomerPaymentMethod.find_by(token: params[:id], company: @company)
        raise ActiveRecord::RecordNotFound if @customer_payment_method.nil?

        render status: :ok, json: success_json
      end

      def create
        @payment_method = find_payment_method
        @customer = Customer.find_by(token: customer_payment_method_params[:customer_token], company: @company)

        @customer_payment_method = CustomerPaymentMethod.new(
          payment_method: @payment_method, customer: @customer, company: @company
        )
        @customer_payment_method.add_credit_card(credit_card_params) if @payment_method&.credit_card?

        return render status: :created, json: success_json if @customer_payment_method.save

        render status: :unprocessable_entity, json: error_json
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
        payment_setting = @company.find_enabled_payment_setting_by_token(
          customer_payment_method_params[:payment_method_token]
        )
        payment_setting&.payment_method
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
          message: 'Requisição inválida', errors:  @customer_payment_method.errors,
          # TODO: passar entrada do cartão de crédito de volta?
          request: @customer_payment_method.as_json(
            only: %i[],
            include: {
              payment_method: { only: %i[name type_of] },
              customer: { only: %i[token] }, company: { only: %i[legal_name] }
            }
          )
        }
      end
    end
  end
end
