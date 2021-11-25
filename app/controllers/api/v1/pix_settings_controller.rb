class Api::V1::PixSettingsController < Api::V1::ApiController
  before_action :authenticate_company!

  def index
    @pix_settings = PixSetting.includes(:payment_method).where(company: @company, payment_method: { status: :enabled })

    render json: @pix_settings.as_json(except: %i[created_at updated_at],
                                     include: { payment_method: { only: %i[name] } })
  end

  def show
    @pix_setting = PixSetting.where(token: params[:id]).first
    raise ActiveRecord::RecordNotFound if @pix_setting.nil?

    return render_not_authorized if @pix_setting.company != @company
    

    render json: @pix_setting.as_json(except: %i[created_at updated_at],
      include: { payment_method: { only: %i[name status] } })
  end
end