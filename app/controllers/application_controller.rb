class ApplicationController < ActionController::Base
  protect_from_forgery

  def set_admin_locale
    I18n.locale = :en
  end

  # fix error Missing template ... with {:locale=>[:en, :nl], :formats=>[:mobile],
  # https://rollbar.com/Vicancy/VideoPipeline/items/2/?item_page=0
  # solution http://stackoverflow.com/questions/10526214/actionviewmissingtemplate-missing-template-trying-to-render-nonexistent-mob
  def formats=(values)
    values = values + [:html, :json] if values == [:mobile]
    super(values)
  end

  # Allow mobile views
  before_filter :prepare_for_mobile

	private

	def mobile_device?
	  if session[:mobile_param]
	    session[:mobile_param] == "1"
	  else
	    request.user_agent =~ /Mobile|iP(hone|od|ad)|Android|BlackBerry|IEMobile|Kindle|NetFront|Silk-Accelerated|(hpw|web)OS|Fennec|Minimo|Opera M(obi|ini)|Blazer|Dolfin|Dolphin|Skyfire|webOS|Zune/
	  end
	end
	helper_method :mobile_device?

	def prepare_for_mobile
	  session[:mobile_param] = params[:mobile] if params[:mobile]
	  request.format = :mobile if mobile_device?
	end
	# /End Mobile stuff

end
