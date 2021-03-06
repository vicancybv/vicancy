class SimpleOrdersController < ApplicationController
  def create
    data = params.require('sf_register_user')
    simple_order = SimpleOrder.create!({
                            params: data.to_hash.to_yaml,
                            referer: request.referer,
                            name: data['name'],
                            email: data['email'],
                            url: data['url'],
                            product: data['product']
                        })
    AdminMailer.delay.notify_simple_order(simple_order, request.ip)
    url = generate_thank_you_url request.referer
    redirect_to url
  end

  def generate_thank_you_url(referer)
    if referer.blank?
      'http://www.vicancy.com/thank-you/'
    else
      uri = URI(referer)
      if uri.path == '/'
        uri.path = '/nl-thank-you/'
      elsif uri.path.starts_with? '/nl-'
        uri.path = '/nl-thank-you/'
      else
        uri.path = '/thank-you/'
      end
      uri.to_s
    end
  end
end
