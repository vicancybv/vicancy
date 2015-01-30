class EmbedController < ApplicationController
  def test
    @video = Video.joins(:client).where('NOT (external_job_id IS NULL)').where('NOT (clients.external_id LIKE \'?*\')').order('updated_at DESC').first
    render layout: false
  end
end
