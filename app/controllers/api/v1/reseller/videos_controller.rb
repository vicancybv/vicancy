class API::V1::Reseller::VideosController < API::BaseController
  before_filter :set_reseller_secure

  def list
    @videos = []
    @reseller.clients.each do |client|
      @videos = @videos + client.videos.to_a
    end
    @videos.sort! { |v1, v2| -1 * (v1.created_at <=> v2.created_at) }
  end

end