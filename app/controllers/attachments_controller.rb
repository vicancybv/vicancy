class AttachmentsController < ApplicationController

  before_filter :authenticate_admin_user!

  def show
    @attachment = Attachment.find(params[:id])
    redirect_to @attachment.file.expiring_url
  end

end
