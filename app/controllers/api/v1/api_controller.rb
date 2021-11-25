module Api
  module V1
    class ApiController < ActionController::API
      rescue_from ActiveRecord::ActiveRecordError, with: :render_generic_error
      rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

      private

      def render_not_found(_error)
        render status: :not_found, json: '{ message: Objeto não encontrado }'
      end

      def render_generic_error(_error)
        render status: :internal_server_error, json: '{ message: Erro geral }'
      end
    end
  end
end
