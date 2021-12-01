module Api
  module V1
    class CustomerSubscriptionsController < Api::V1::ApiController
      def create
        sanitized_params = customer_subscription_params

        customer_payment_method = find_by_token(CustomerPaymentMethod,
                                                sanitized_params[:customer_payment_method_token])
        subscription = find_by_token(Product, sanitized_params[:subscription_token])

        @customer_subscription = CustomerSubscription.new(
          cost: sanitized_params[:cost],
          company: @company,
          customer_payment_method: customer_payment_method,
          product: subscription
        )

        render status: :created, json: success_json if @customer_subscription.save
      end

      private

      def customer_subscription_params
        params.require(:customer_subscription).permit(:customer_payment_method_token, :subscription_token, :cost)
      end

      def success_json
        @customer_subscription.as_json(
          only: %i[token renovation_date status cost],
          include: {
            product: { only: %i[name type_of token] },
            customer_payment_method: { only: %i[token] },
            company: { only: %i[legal_name] }
          }
        )
      end
    end
  end
end
