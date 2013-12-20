class VideosController < ApplicationController

  def destroy
  	@video = Video.find(params[:id])
    raise ActiveRecord::RecordNotFound unless @video
    AdminMailer.delete_video_email(@video, request.ip).deliver
    render nothing:true
  end

end
