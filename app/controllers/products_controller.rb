class ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_product_and_authenticate_company, only: %i[show enable disable]
  before_action :redirect_if_pending_company

  def index; end

  def show; end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(params.require(:product).permit(:name))
    @product.company = current_user.company

    if @product.save
      redirect_to @product, notice: t('.create_success_notice')
    else
      render :new
    end
  end

  def disable
    @product.disabled!
    redirect_to @product
  end

  def enable
    @product.enabled!
    redirect_to @product
  end
end
