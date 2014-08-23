class API::V1::ClientController < API::BaseController
  before_filter :set_reseller, only: [:auth]

  def auth
    client_params = params.require(:client)
    begin
      @client = @reseller.clients.find_by_external_id(client_params.require(:id))
      unless @client.blank?
        attrs = client_params.permit(:name, :email, :language)
        unless @client.same_session?(DateTime.now, request.remote_ip)
          attrs[:sign_in_count] = @client.sign_in_count.blank? ? 1 : @client.sign_in_count.to_i + 1
          attrs[:last_sign_in_at] = @client.current_sign_in_at
          attrs[:current_sign_in_at] = DateTime.now
          attrs[:last_sign_in_ip] = @client.current_sign_in_ip
          attrs[:current_sign_in_ip] = request.remote_ip
        end
        @client.update_attributes(attrs)
      else
        @client = Client.create!(
            name: client_params.require(:name),
            email: client_params[:email],
            language: client_params[:language],
            external_id: client_params.require(:id),
            reseller_id: @reseller.id,
            sign_in_count: 1,
            current_sign_in_at: DateTime.now,
            current_sign_in_ip: request.remote_ip
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