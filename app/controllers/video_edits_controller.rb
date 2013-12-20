class VideoEditsController < ApplicationController

  def new
    @video = Video.find(params[:video_id])
    raise ActiveRecord::RecordNotFound unless @video
    @video_edit = @video.video_edits.new
    render layout: false
  end

  def create
    @video = Video.find(params[:video_id])
    raise ActiveRecord::RecordNotFound unless @video
    @video_edit = @video.video_edits.create(params[:video_edit].merge(user_ip: request.remote_ip))
    AdminMailer.edit_video_email(@video_edit, request.ip).deliver
    render nothing: true
  end

end