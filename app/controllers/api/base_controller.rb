class AuthenticationError < StandardError; end

class API::BaseController < ActionController::Base
  protect_from_forgery

  rescue_from StandardError, with: :rescue_error
  rescue_from AuthenticationError, with: :rescue_auth_error


  def set_reseller
    @reseller = Reseller.find_by_token!(params.require(:api_token))
  rescue ActiveRecord::RecordNotFound
    raise AuthenticationError.new('Unknown reseller')
  end

  def set_reseller_secure
    reseller = Reseller.find_by_token!(params.require(:api_token))
    sleep 0.3 # to prevent time-attacks and brute force attacks
    if reseller.secret == params.require(:api_secret)
      @reseller = reseller
    else
      raise AuthenticationError.new('Unknown reseller')
    end
  rescue ActiveRecord::RecordNotFound
    raise AuthenticationError.new('Unknown reseller')
  end

  def set_client
    @client = @reseller.clients.find_by_token!(params.require(:client_token))
  rescue ActiveRecord::RecordNotFound
    raise AuthenticationError.new('Unknown client')
  end

  def set_client_by_id
    @client = @reseller.clients.find_by_external_id!(params.require(:client_id))
  rescue ActiveRecord::RecordNotFound
    raise AuthenticationError.new('Unknown client')
  end

  private

  def rescue_auth_error(e)
    rescue_error(e, 401)
  end

  def rescue_error(e, status = 500)
    Rollbar.report_exception(e, rollbar_request_data, rollbar_person_data)

    logger.error e.inspect
    logger.error e.backtrace.join("\n")

    @error = e
    response = {
        status: 'error',
        error_text: "#{e.message}"
    }

    respond_to do |format|
      format.html { render 'api/v1/error', layout: 'api_error', status: status }
      format.json { render json: response, status: status  }
    end
  end

end