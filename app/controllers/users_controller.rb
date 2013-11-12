class UsersController < ApplicationController

  def show
    @user = User.where(slug: params[:id]).first
    raise ActiveRecord::RecordNotFound unless @user
  end

end
