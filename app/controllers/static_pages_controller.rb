class StaticPagesController < ApplicationController

  caches_action [:index, :pricing, :product, :team, :videoconsultancy]

  layout "static"

  def index
    render layout: "static_index"
  end

  def pricing
    render layout: "static_index"
  end

  def product
    render layout: "static_index"
  end

  def team
    render layout: "static_index"
  end

  def videoconsultancy
    render layout: "static_index"
  end


  Vicancy::STATIC_PAGE_SLUGS.each do |slug|
    define_method slug do
    end
  end

end
