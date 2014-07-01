class API::V1::ClientController < API::BaseController
  before_filter :set_user, only: [:auth]

  def auth
    client_params = params.require(:client)
    @client = @user.clients.find_by_external_id(client_params.require(:id))
    unless @client.blank?
      @client.update_attributes(client_params.permit(:name, :email, :language))
    else
      @client = Client.create!(
          name: client_params.require(:name),
          email: client_params.require(:email),
          language: client_params[:language],
          external_id: client_params.require(:id),
          user_id: @user.id
      )
    end
  end

  private

  def set_user
    @user = User.find_by_token!(params.require(:api_token))
  end

end