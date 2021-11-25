class Api::V1::BoletoSettingsController < Api::V1::ApiController
  def index
    company = Company.where(token: params[:token_company])
    @boleto_settings = BoletoSetting.includes(:payment_method).where(company: company, payment_method: { status: :enabled })

    
    render json: @boleto_settings.as_json(except: %i[created_at updated_at property_type_id],
                                     include: { payment_method: { only: %i[name] } })
  end
end