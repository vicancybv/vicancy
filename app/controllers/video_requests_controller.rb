class VideoRequestsController < ApplicationController

  def create
    @video_request = VideoRequest.new(params[:video_request])
    @video_request.user_ip = request.remote_ip
    @video_request.save
    AdminMailer.video_request_email(@video_request).deliver
    render nothing:true
  end

end
