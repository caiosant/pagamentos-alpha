class ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_user_company_accepted

  def index; end

  def show
    @product = Product.find(params[:id])
  end

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
end
