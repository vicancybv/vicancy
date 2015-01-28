class API::V1::ResellerController < API::BaseController
  before_filter :set_reseller, only: [:new_video_request]
  before_filter :set_client, only: [:new_video_request]

  def new_video_request
    @p = new_video_params
    @job_id = new_video_params.require(:job_id)
    if @client.has_video_for_job(@job_id)
      # CGI.escape incorrectly encodes spaces in query values to '+' instead of '%20'
      # it introduces problems with Ember.js decoder, which doesn't decodes +'s resulting in
      # incorrect query param values
      queries = []
      redirect_params.each { |key, value| queries << "#{ERB::Util.url_encode key.to_s}=#{ERB::Util.url_encode value.to_s}" }
      @url = "/widget#/?#{queries.join('&')}"
      render 'open_widget', layout: nil
    else
      @client.mark_sign_in(request.remote_ip)
      @video_request = VideoRequest.where({ external_job_id: @job_id, client_id: @client.id }).first
      if @video_request.present?
        render 'processing', layout: 'reseller_api'
      elsif @video_request.blank? && (new_video_params[:create] == 'true')
        @video_request = VideoRequest.create!({
                                                  link: new_video_params.require(:job_url),
                                                  comment: new_video_params[:comment],
                                                  external_job_id: @job_id,
                                                  job_title: new_video_params[:job_title],
                                                  job_body: new_video_params[:job_body],
                                                  client_logo: new_video_params[:client_logo],
                                                  client_id: @client.id,
                                                  user_ip: request.remote_ip
                                              })
        AdminMailer.video_request_email(@video_request).deliver
        render 'created', layout: 'reseller_api'
      else
        render 'confirm', layout: 'reseller_api'
      end
    end
  end

  private

  def new_video_params
    params.permit(:api_token, :client_id, :client_name, :client_email, :language, :comment, :job_url, :job_id, :job_title, :job_body, :client_logo, :create)
  end
  def redirect_params
    params.permit(:api_token, :client_id, :client_name, :client_email, :language, :job_id)
  end

  def set_client
    attrs = {
        external_id: new_video_params.require(:client_id),
        name: new_video_params.require(:client_name),
        email: new_video_params[:client_email],
        language: new_video_params[:language]
    }
    @client = Client.fetch(@reseller, attrs)
  end
end
