class ResellersController < ApplicationController
  layout 'resellers'
  before_filter :set_reseller

  def clients
  end

  private

  def set_reseller
    id = normalize_whitespaces(params.require(:id))
    @reseller = Reseller.find_by_slug(id)
    raise ActiveRecord::RecordNotFound if @reseller.blank?
    I18n.locale = @reseller.language if @reseller.language.present?
  end
end
