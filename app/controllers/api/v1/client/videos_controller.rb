class API::V1::Client::VideosController < API::BaseController
  before_filter :set_client
  before_filter :set_video, only: [:edit]

  def index
    @videos = @client.videos.order('updated_at DESC').to_a
  end

  def edit
    @video_edit = @video.video_edits.create({
                                                edits: params.require(:edit).require(:comments),
                                                user_ip: request.remote_ip
                                            })
    AdminMailer.edit_video_email(@video_edit, request.ip).deliver
  end

  def video_request
    @video_request = VideoRequest.new(params.require(:request).permit(:link, :comment))
    @video_request.client_id = @client.id
    @video_request.user_ip = request.remote_ip
    @video_request.save!
    AdminMailer.video_request_email(@video_request).deliver
  end

  private

  def set_video
    @video = Video.find(params.require(:id))
  end

  def set_client
    @reseller = Reseller.find_by_token!(params.require(:api_token))
    @client = @reseller.clients.find_by_token!(params.require(:client_token))
  end

end