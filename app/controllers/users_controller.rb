class UsersController < ApplicationController

  def show
    @user = User.where(slug: params[:id]).first
    I18n.locale = @user.language unless @user.language.blank?
    raise ActiveRecord::RecordNotFound unless @user
  end

end
