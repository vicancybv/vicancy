class API::V1::Client::VideosController < API::BaseController
  before_filter :set_reseller
  before_filter :set_client
  before_filter :set_video, only: [:edit, :delete]

  def index
    @videos = @client.videos.order('created_at DESC').to_a
    @requests = @client.video_requests.exists?
  end

  def edit
    @video_edit = @video.video_edits.create!({
                                                edits: params.require(:edit).require(:comments),
                                                user_ip: request.remote_ip
                                            })
    AdminMailer.edit_video_email(@video_edit, request.ip).deliver
  end

  def delete
    AdminMailer.delete_video_email(@video, request.ip).deliver
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
    @video = Video.where(id: params.require(:id), client_id: @client.id).first
    raise ActiveRecord::RecordNotFound unless @video
  end

end