class WidgetController < ApplicationController
  layout 'widget'

  def show
  end

  def test_request_vicancy
    render layout: false
  end

  def embed
    render layout: false
  end

  def test
    render layout: false
  end
end
