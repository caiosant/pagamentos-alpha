class Api::V1::CustomerController < Api::V1::ApiController

  def create
    @customer = Customer.new(customer_params)
    @customer.company = @company
    
    if @customer.save
      render status: 201, json: { name: @customer.name,
                                  cpf: @customer.cpf,
                                  customer_token: @customer.token }
    else
      render status: 422, json: { message: 'Requisição inválida',
                                  errors:  @customer.errors ,
                                  request: @customer.as_json(except: %i[id token company_id 
                                                                        created_at updated_at])
                                }    
    end
  end

  private
  def customer_params
    params.require(:customer).permit(:name, :cpf)
  end
end
