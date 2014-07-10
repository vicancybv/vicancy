class API::V1::Client::VideosController < API::BaseController
  before_filter :set_client

  def index
    @videos = @client.user.videos.order('updated_at DESC').to_a
  end

  private

  def set_client
    @user = User.find_by_token!(params.require(:api_token))
    @client = @user.clients.find_by_token!(params.require(:client_token))
  end

end