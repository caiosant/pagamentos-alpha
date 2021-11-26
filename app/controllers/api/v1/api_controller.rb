class Api::V1::ApiController < ActionController::API
  rescue_from ActiveRecord::ActiveRecordError, with: :render_generic_error
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  ActiveRecord::Base.include_root_in_json = true
  before_action :authenticate_company!


  private
  
  def authenticate_company!
    @company = Company.find_by(token: request.headers['companyToken'])
    render_not_authorized if @company.nil?
  end

  def render_not_authorized
    render status: 401, json: { message: 'Há algo errado com sua autenticação.' }
  end

  def render_not_found(e)
    render status: 404, json: { message: 'Objeto não encontrado' }
  end

  def render_generic_error(e)
    render status: 500, json: { message: 'Erro geral' }
  end
end
