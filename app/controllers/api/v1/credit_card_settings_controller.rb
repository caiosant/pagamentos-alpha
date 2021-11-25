module Api
  module V1
    class CreditCardSettingsController < Api::V1::ApiController
      def index
        company = Company.where(token: params[:token_company])
        @credit_card_settings = CreditCardSetting.includes(:payment_method).where(company: company,
                                                                                  payment_method: { status: :enabled })

        render json: @credit_card_settings.as_json(except: %i[created_at updated_at property_type_id],
                                                   include: { payment_method: { only: %i[name] } })
      end
    end
  end
end
