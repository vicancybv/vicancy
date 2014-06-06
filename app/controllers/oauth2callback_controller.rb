class Oauth2callbackController < ActionController::Base

	def index
    google_session = GoogleSession.find || GoogleSession.new
    Rails.logger.info "* #{params[:code]}"
    google_session.get_access_token!(params[:code])
    flash[:notice] = "Google session setup successfully" if GoogleSession.find
    redirect_to admin_admin_users_path
	end

end