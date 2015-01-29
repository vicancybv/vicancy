class API::V1::Client::VideosController < API::BaseController
  before_filter :set_reseller
  before_filter :set_client, except: [:embed_code]
  before_filter :set_video, only: [:edit, :delete]
  before_filter :set_client_by_id, only: [:embed_code]
  before_filter :set_video_by_job_id, only: [:embed_code]

  def embed_code

  end

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

  def add
    @video_request = VideoRequest.new({
                                          link: add_params.require(:link),
                                          comment: add_params[:comment],
                                          external_job_id: add_params[:job_id]
                                      })
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

  def set_video_by_job_id
    @video = Video.where(external_job_id: params.require(:job_id), client_id: @client.id).first
    raise ActiveRecord::RecordNotFound unless @video
  end

  def add_params
    params.require(:request).permit(:link, :comment, :job_id)
  end
end