class StaticPagesController < ApplicationController

  caches_action [:index, :en]

  layout "static"

  def mobile_device?
    request.user_agent =~ /Mobile|webOS/
  end
  helper_method :mobile_device?

  def index
    if mobile_device?
      match '/' => redirect('/mobile') 
    else
      render layout: "static_index"
    end
  end

  def en
    render layout: "static_index"
  end
  def en_edited
    render layout: "static_index"
  end


  Vicancy::STATIC_PAGE_SLUGS.each do |slug|
    define_method slug do
    end
  end

end
