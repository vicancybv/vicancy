class ContactController < ApplicationController
  skip_before_filter :verify_authenticity_token
  
  def submit_message
    ContactMailer.message_email(params[:name], params[:email], params[:message]).deliver
    render text: "1"
  end

end
