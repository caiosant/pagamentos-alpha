class ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_user_company_accepted

  def index
  end

  def new
    @product = Product.new
  end
end