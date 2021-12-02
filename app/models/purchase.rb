class Purchase < ApplicationRecord
  belongs_to :customer_payment_method
  belongs_to :product
  belongs_to :company
  has_one :receipt, dependent: :destroy

  after_create :generate_token_attribute

  enum status: { pending: 0, paid: 5 }

  validates :cost, presence: true

  def validate_product_is_not_subscription
    return unless product.subscription?

    errors.add :product, 'não crie cobrança de assinatura diretamente pela API'
  end

  def self.search(params, company_object)
    @purchases = Purchase.all.where(company: company_object)
    return @purchases if params.empty?

    if params.count <= 3
      if params.key?(:customer_token)
        customer = Customer.find_by(token: params[:customer_token])
        customer_payment_method = CustomerPaymentMethod.find_by(customer: customer)
        @purchases = @purchases.where(customer_payment_method: customer_payment_method)
        params.delete(:customer_token)
      end

      if params.key?(:type)
        @purchases = @purchases.includes(:customer_payment_method).where(
          customer_payment_method: { type_of: params[:type] }
        )
        params.delete(:type)
      end

      if params.key?(:product_token)
        product_filter = Product.find_by(token: params[:product_token])
        @purchases = @purchases.where(product: product_filter)
        params.delete(:product_token)
      end
    end

    params.empty? ? @purchases : nil
  end
end
