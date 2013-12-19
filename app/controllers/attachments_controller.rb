class AttachmentsController < ApplicationController

  before_filter :authenticate_admin_user!

  def show
    @attachment = Attachment.find(params[:id])
    redirect_to @attachment.file.expiring_url(1.week)
  end

  def download
    @attachment = Attachment.find(params[:id])
    data = open(@attachment.file.expiring_url) 
    send_data data.read, { disposition: "attachment", filename: @attachment.file_file_name, content_type: "application/octet-stream"}
  end

end
