class API::V1::Client::VideosController < API::BaseController
  before_filter :set_client

  def index
    @videos = @client.videos.order('updated_at DESC').to_a
  end

  def video_request
    @video_request = VideoRequest.new(params[:request])
    @video_request.user_ip = request.remote_ip
    @video_request.save!
    AdminMailer.video_request_email(@video_request).deliver
  end

  private

  def set_client
    @reseller = Reseller.find_by_token!(params.require(:api_token))
    @client = @reseller.clients.find_by_token!(params.require(:client_token))
  end

end