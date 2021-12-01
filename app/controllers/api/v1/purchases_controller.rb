module Api
  module V1
    class PurchasesController < Api::V1::ApiController
      def index
        @purchases = Purchase.search(request.query_parameters, @company)

        if @purchases.nil?
          render status: :bad_request, json: { message: 'Parâmetro Inválido' }
        else
          render status: :ok, json: @purchases.as_json(except: %i[id customer_payment_method_id pix_setting_id
                                                                  boleto_setting_id credit_card_setting_id product_id
                                                                  receipt_id company_id created_at updated_at],
                                                       include: {
                                                         company: { only: :legal_name },
                                                         product: { only: %i[name token] },
                                                         customer_payment_method: { only: :token }
                                                       })
        end
      end

      def show
        @purchase = Purchase.find_by(token: params[:id])
        raise ActiveRecord::RecordNotFound if @purchase.nil?

        return render_not_authorized if @purchase.company != @company

        render status: :ok, json: @purchase.as_json(except: %i[id customer_payment_method_id pix_setting_id
                                                               boleto_setting_id credit_card_setting_id product_id
                                                               receipt_id company_id created_at updated_at],
                                                    include: {
                                                      company: { only: :legal_name },
                                                      product: { only: %i[name token] },
                                                      customer_payment_method: { only: :token }
                                                    })
      end

      def create
        sanitized_params = purchase_params
        @purchase = @company.purchases.new
        @purchase.product = find_by_token(Product, sanitized_params[:product_token])
        @purchase.validate_product_is_not_subscription
        @purchase.customer_payment_method = find_by_token(CustomerPaymentMethod,
                                                          sanitized_params[:customer_payment_method_token])

        if @purchase.errors.empty? && @purchase.save
          render status: :created, json: @purchase.as_json(except: %i[id customer_payment_method_id pix_setting_id
                                                                      boleto_setting_id credit_card_setting_id product_id
                                                                      receipt_id company_id created_at updated_at],
                                                           include: {
                                                             company: { only: :legal_name },
                                                             product: { only: %i[name token] },
                                                             customer_payment_method: { only: [:token] }
                                                           })
        else
          render status: :unprocessable_entity, json: { message: 'Requisição inválida', errors: @purchase.errors,
                                                        request: @purchase.as_json(except: %i[id token company_id
                                                                                              created_at updated_at]) }
        end
      end

      private

      def purchase_params
        params.require(:purchase).permit(
          :product_token,
          :purchase_payment_method_token,
          :customer_payment_method_token
        )
      end
    end
  end
end
