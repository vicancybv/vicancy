class StaticPagesController < ApplicationController

  caches_action [:index, :en]

  layout "static"

  def index
    render layout: "static_index"
  end

  def en
    render layout: "static_index"
  end

  Vicancy::STATIC_PAGE_SLUGS.each do |slug|
    define_method slug do
    end
  end

end
