class API::V1::ClientController < API::BaseController
  before_filter :set_reseller, only: [:auth]
  before_filter :set_client, only: [:auth]

  def auth
    @client.mark_sign_in(request.remote_ip)
  end

  private

  def set_client
    client_params = params.require(:client)
    id = client_params.require(:id)
    email = client_params[:email]
    name = client_params[:name]
    name = email if name.blank?
    raise ActionController::ParameterMissing.new('param is missing or the value is empty: name') if name.blank?
    attrs = {
        external_id: id,
        name: name,
        email: email,
        language: client_params[:language]
    }
    @client = Client.fetch(@reseller, attrs)
  end
end