class SimpleOrdersController < ApplicationController
  def create
    data = params.require('sf_register_user')
    SimpleOrder.create!({
                            params: data.to_hash.to_yaml,
                            referer: request.referer,
                            name: data['name'],
                            email: data['email'],
                            url: data['url'],
                            product: data['product']
                        })
    redirect_to 'http://www.vicancy.com/thank-you/'
  end
end
