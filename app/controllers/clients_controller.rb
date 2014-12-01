class ClientsController < ApplicationController
  layout false

  def show
    id = normalize_whitespaces(params.require(:id))
    @client = Client.find_by_slug(id)
    raise ActiveRecord::RecordNotFound if @client.blank?
    I18n.locale = @client.language if @client.language.present?
  end

end
