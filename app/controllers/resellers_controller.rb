class ResellersController < ApplicationController

  def show
    @reseller = Reseller.find_by_slug(params[:id])
    raise ActiveRecord::RecordNotFound if @reseller.blank?
    I18n.locale = @reseller.language if @reseller.language.present?
  end

end
