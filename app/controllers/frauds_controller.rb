class FraudsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @purchases = Purchase.all.where(status: 'rejected')
  end

  def show
    @purchase = Purchase.find(params[:id])
  end

  def new
    @purchase = Purchase.find(params[:purchase_id])
    @fraud = Fraud.new
  end

  def create
    @purchase = Purchase.find(params[:purchase_id])
    @fraud = @purchase.fraud.new(fraud_params)

    if @fraud.save
      @purchase.rejected!
      purchases_path
    else
      render :new
    end
  end

  private

  def fraud_params
    params.require(:fraud).permit(:title, :description)
  end
end
