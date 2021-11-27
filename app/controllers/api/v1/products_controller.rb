module Api
  module V1
    class ProductsController < Api::V1::ApiController
      def index
        @products = Product.where(company: @company, status: :enabled)

        render json: @products.as_json(only: %i[name token status])
      end

      def show
        @product = find_by_token(Product, params[:id])

        return render_not_authorized if @product.company != @company

        render json: @product.as_json(only: %i[name token status])
      end

      def enable
        @product = find_by_token(Product, params[:id])
        return render_not_authorized if @product.company != @company

        @product.enabled!
      end

      def disable
        @product = find_by_token(Product, params[:id])
        return render_not_authorized if @product.company != @company

        @product.disabled!
      end

      def create
        @product = Product.new(product_params)
        @product.company = @company

        if @product.save
          render status: :created, json: { name: @product.name, token: @product.token }
        else
          render status: :unprocessable_entity, json: { message: 'Requisição inválida',
                                                        errors: @product.errors,
                                                        request: @product.as_json(except: %i[id token company_id
                                                                                             created_at updated_at]) }
        end
      end

      private

      def product_params
        params.require(:product).permit(:name)
      end
    end
  end
end
