module Api
  module V1
    class PurchasesController < Api::V1::ApiController
      def create
        sanitized_params = purchase_params
        @purchase = @company.purchases.new()
        
        case sanitized_params[:payment_setting_type]
        when 'pix'
          @purchase.pix_setting = find_by_token(PixSetting, sanitized_params[:payment_setting_token])
        when 'boleto'
          @purchase.boleto_setting = find_by_token(BoletoSetting, sanitized_params[:payment_setting_token])
        when 'credit_card'
          @purchase.credit_card_setting = find_by_token(CreditCardSetting, sanitized_params[:payment_setting_token])
        else
        end
        
        @purchase.type_of = sanitized_params[:payment_setting_type]
        @purchase.product = find_by_token(Product, sanitized_params[:product_token])

        @purchase.customer_payment_method = find_by_token(CustomerPaymentMethod, sanitized_params[:customer_payment_method_token])
        
        if @purchase.save
          render status: :created, json: @purchase.as_json(except: %i[id customer_payment_method_id pix_setting_id 
                                                                      boleto_setting_id credit_card_setting_id product_id 
                                                                      receipt_id company_id created_at updated_at],
                                                           include: {
                                                             company: { only: :legal_name },
                                                             product: { only: [:name, :token] }, 
                                                             pix_setting: { only: [:token] },
                                                             boleto_setting: { only: [:token] },
                                                             credit_card_setting: { only: [:token] },
                                                             customer_payment_method: { only: [:token] }
                                                           })
        else
          render status: :unprocessable_entity, json: { message: 'Requisição inválida', errors: @purchase.errors,
                                                        request: @purchase.as_json(except: %i[id token company_id
                                                                                              created_at updated_at]) }
        end
      end

      def index 
        @purchases = Purchase.all.where(company: @company)

        render status: :ok, json: @purchases.as_json(except: %i[id customer_payment_method_id pix_setting_id 
                                                        boleto_setting_id credit_card_setting_id product_id 
                                                        receipt_id company_id created_at updated_at],
                                              include: {
                                              company: { only: :legal_name },
                                              product: { only: [:name, :token] }, 
                                              pix_setting: { only: :token },
                                              boleto_setting: { only: :token },
                                              credit_card_setting: { only: :token },
                                              customer_payment_method: { only: :token }
                                            })
      end

      private

      def purchase_params
        params.require(:purchase).permit(
          :product_token, 
          :payment_setting_token,
          :payment_setting_type,
          :purchase_payment_method_token,
          :customer_payment_method_token
        )
      end
    end
  end
end
