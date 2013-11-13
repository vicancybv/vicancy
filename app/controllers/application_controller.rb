class ApplicationController < ActionController::Base
  protect_from_forgery

  def set_admin_locale
    I18n.locale = :nl
  end
end
