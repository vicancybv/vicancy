class AuthenticationError < StandardError; end

class API::BaseController < ApplicationController
  rescue_from StandardError, with: :rescue_error
  rescue_from AuthenticationError, with: :rescue_auth_error


  def set_reseller
    @reseller = Reseller.find_by_token!(params.require(:api_token))
  rescue ActiveRecord::RecordNotFound
    raise AuthenticationError.new('Unknown reseller')
  end

  def set_client
    @client = @reseller.clients.find_by_token!(params.require(:client_token))
  rescue ActiveRecord::RecordNotFound
    raise AuthenticationError.new('Unknown client')
  end

  private

  def rescue_auth_error(e)
    rescue_error(e, 401)
  end

  def rescue_error(e, status = 500)
    logger.error e.inspect
    logger.error e.backtrace.join("\n")

    response = {
        status: 'error',
        error_text: "#{e.message}"
    }

    render json: response, status: status
  end

end