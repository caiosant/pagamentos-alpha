module Api
  module V1
    class BoletoSettingsController < Api::V1::ApiController
      def index
        @boleto_settings = BoletoSetting.includes(:payment_method).where(company: @company,
                                                                         payment_method: { status: :enabled })

        render json: @boleto_settings.as_json(
          except: %i[created_at updated_at property_type_id company_id payment_method_id],
          include: { payment_method: { only: %i[name id] } }
        )
      end

      def show
        @boleto_setting = BoletoSetting.where(token: params[:id]).first
        raise ActiveRecord::RecordNotFound if @boleto_setting.nil?

        return render_not_authorized if @boleto_setting.company != @company

        render json: @boleto_setting.as_json(
          except: %i[created_at updated_at property_type_id company_id payment_method_id],
          include: { payment_method: { only: %i[
            name id status
          ] } }
        )
      end
    end
  end
end
