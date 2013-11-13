class VideosController < ApplicationController

  def destroy
  	@video = Video.find(params[:id])
    raise ActiveRecord::RecordNotFound unless @video
    AdminMailer.delete_video_email(@video, request.ip).deliver
    render nothing:true
  end

  def edit
    @video = Video.find(params[:id])
    raise ActiveRecord::RecordNotFound unless @video
    render layout: false
  end

  def update
    @video = Video.find(params[:id])
    @video.edits = params[:video][:edits]
    raise ActiveRecord::RecordNotFound unless @video
    AdminMailer.edit_video_email(@video, request.ip).deliver
    render nothing: true
  end

end
