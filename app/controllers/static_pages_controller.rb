class StaticPagesController < ApplicationController

  layout false


  Vicancy::STATIC_PAGE_SLUGS.each do |slug|
    define_method slug do
    end
  end

end
