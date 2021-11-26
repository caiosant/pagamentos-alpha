class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_subscription_and_authenticate_company, only: %i[show enable disable]
  before_action :redirect_if_pending_company
  before_action :authenticate_company_user, only: %i[enable disable]

  def show; end

  def new
    @subscription = Subscription.new
  end

  def create
    @subscription = Subscription.new(subscription_params)
    @subscription.company = current_user.company

    if @subscription.save
      redirect_to subscription_path(@subscription), notice: t('.create_success_notice')
    else
      render :new
    end
  end

  def enable
    @subscription.enabled!
  end

  def disable
    @subscription.disabled!
  end

  private

  def subscription_params
    params.require(:subscription).permit(:name)
  end
end
