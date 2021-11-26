module Api
  module V1
    class ProductsController < Api::V1::ApiController
      def create
        @product = Product.new(params.require(:product).permit(:name))
        @product.company = @company
        
        if @product.save
          render status: 201, json: { name: @product.name, token: @product.token}
        else
          render status: 422, json: { message: 'Requisição inválida',
                                      errors:  @product.errors ,
                                      request: @product.as_json(except: %i[id token company_id 
                                                                            created_at updated_at])
                                    }    
        end
      end
    end
  end
end