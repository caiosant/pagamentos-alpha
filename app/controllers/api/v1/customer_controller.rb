class Api::V1::CustomerController < Api::V1::ApiController
  def create
    render status: 200, json: {token: '73grr29y'}.as_json
  end
end
