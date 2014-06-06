class VimeoImportsController < ApplicationController

  def new
    @vimeo_import = VimeoImport.new
  end

  def create
    @vimeo_import = VimeoImport.new(vimeo_id: params[:vimeo_import][:vimeo_id])
    if !params[:vimeo_import][:url].starts_with?("http")
      flash[:error] = "Invalid URL"
      redirect_to new_vimeo_import_url
    else
      thread = WistiaUploader.upload_media(ENV['WISTIA_API_PASSWORD'], ENV['WISTIA_PROJECT_ID'], params[:vimeo_import][:url])
      # Wait for thread to complete
      thread.join
      response = JSON.parse(thread[:body])
      if thread[:upload_status] == :success && wistia_id = response["id"]
        @vimeo_import.wistia_id = wistia_id
        @vimeo_import.save
        flash[:notice] = "Import succeeded"
        redirect_to new_vimeo_import_url
      else
        flash[:error] = "Import failed: #{response.inspect}"
        render :new
      end
    end

  end

end
