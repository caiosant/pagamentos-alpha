class Api::V1::CustomerController < Api::V1::ApiController

  def index
    @customers = Customer.all.where(company: @company)

    render status:200, json: @customers.as_json( except: %i[id company_id 
                                                 created_at updated_at], 
                                                 include: { company: { only: :legal_name } } )
  end

  def show
    @customers = Customer.all.where(company: @company)

    render status:200, json: @customers.as_json( except: %i[id company_id 
                                                 created_at updated_at], 
                                                 include: { company: { only: :legal_name } } )
  end

  def create
    @customer = Customer.new(customer_params)
    @customer.company = @company
    
    if @customer.save
      render status: 201, json: @customer.as_json( except: %i[id company_id 
                                                  created_at updated_at], 
                                                  include: { company: { only: :legal_name } } )

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
