class API::BaseController < ApplicationController
  rescue_from StandardError, with: :rescue_error
  rescue_from ActionController::ParameterMissing, with: :rescue_parameter_missing
  rescue_from ActiveRecord::RecordNotFound, with: :rescue_record_not_found

  private

  def rescue_record_not_found(e)
    #e.message.replace('Unknown token') if e.message.include? 'Couldn\'t find User'
    rescue_error(e, 404)
  end

  def rescue_parameter_missing(e)
    rescue_error(e, 422)
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