class API::V1::ClientController < API::BaseController
  before_filter :set_reseller, only: [:auth]

  def auth
    client_params = params.require(:client)
    begin
      @client = @reseller.clients.find_by_external_id(client_params.require(:id))
      unless @client.blank?
        @client.update_attributes(client_params.permit(:name, :email, :language))
      else
        @client = Client.create!(
            name: client_params.require(:name),
            email: client_params[:email],
            language: client_params[:language],
            external_id: client_params.require(:id),
            reseller_id: @reseller.id
        )
      end
    rescue ActiveRecord::RecordNotUnique
      retry
    end
  end

  private

  def set_reseller
    @reseller = Reseller.find_by_token!(params.require(:api_token))
  end

end