class API::V1::ClientController < API::BaseController
  before_filter :set_reseller, only: [:auth]
  before_filter :set_client, only: [:auth]

  def auth
    @client.mark_sign_in(request.remote_ip)
  end

  private

  def set_client
    client_params = params.require(:client)
    attrs = {
        external_id: client_params.require(:id),
        name: client_params.require(:name),
        email: client_params[:email],
        language: client_params[:language]
    }
    @client = Client.fetch(@reseller, attrs)
  end
end