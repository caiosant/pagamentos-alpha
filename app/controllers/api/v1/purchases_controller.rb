module Api
    module V1
      class PurchasesController < Api::V1::ApiController
        def index
        end

        def show
        end

        def create
            @purchase = Purchacse.new(purchase_params)
        end



        private
        
        def purchase_params
            params.require(:purchase).permit()
      end
    end
end