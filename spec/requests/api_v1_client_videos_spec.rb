require 'spec_helper'

describe '/api/v1/client/videos' do
  let(:user) { create(:user) }
  let(:client) { create(:client, user: user) }
  let(:json) { JSON.parse(response.body) }

  context 'GET /api/v1/client/videos' do

    before(:each) do
      client # create all
      user.videos.create!({
                              job_ad_url: 'http://example',
                              job_title: 'Manager',
                              company: 'Deloitte',
                              language: 'en'
                          })
      user.videos.first.uploaded_videos.create!({provider: 'youtube', provider_id: '1111111'})
      user.videos.first.uploaded_videos.create!({provider: 'vimeo', provider_id: '22222222'})
      get '/api/v1/client/videos', { api_token: user.token, client_token: client.token }
    end


    it 'should return status 200' do
      expect(response.status).to eq 200
    end

    it 'should return json with status ok' do
      expect(json['status']).to eq 'ok'
    end

    it 'should list videos' do
      expect(json['videos'].size).to eq 1
    end

    it 'should return video info' do
      puts json['videos']
      video = json['videos'].first
      expect(video['job_title']).to eq 'Manager'
      expect(video['company']).to eq 'Deloitte'
      expect(video['youtube_id']).to eq '1111111'
      expect(video['vimeo_id']).to eq '22222222'
    end
  end
end
