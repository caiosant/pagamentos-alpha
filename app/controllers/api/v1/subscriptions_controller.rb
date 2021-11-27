module Api
  module V1
    class SubscriptionsController < Api::V1::ApiController
      def index
        @subscriptions = Subscription.where(company: @company, status: :enabled)

        render json: @subscriptions.as_json(only: %i[name token status])
      end

      def show
        @subscription = find_by_token(Subscription, params[:id])

        return render_not_authorized if @subscription.company != @company

        render json: @subscription.as_json(only: %i[name token status])
      end

      def enable
        @subscription = find_by_token(Subscription, params[:id])
        return render_not_authorized if @subscription.company != @company

        @subscription.enabled!
      end

      def disable
        @subscription = find_by_token(Subscription, params[:id])
        return render_not_authorized if @subscription.company != @company

        @subscription.disabled!
      end

      def create
        @subscription = Subscription.new(subscription_params)
        @subscription.company = @company
        if @subscription.save
          render status: :created, json: { name: @subscription.name, token: @subscription.token }
        else
          render status: :unprocessable_entity,
                 json: { message: 'Requisição inválida',
                         errors: @subscription.errors,
                         request: @subscription.as_json(except: %i[id token company_id created_at updated_at]) }
        end
      end

      private

      def subscription_params
        params.require(:subscription).permit(:name)
      end
    end
  end
end
