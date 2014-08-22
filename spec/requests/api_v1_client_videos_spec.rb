require 'spec_helper'

describe '/api/v1/client/videos' do
  let(:reseller) { create(:reseller) }
  let(:client) { create(:client, reseller: reseller) }
  let(:json) { JSON.parse(response.body) }

  context 'GET /api/v1/client/videos' do

    before(:each) do
      client # create all
      client.videos.create!({
                              job_ad_url: 'http://example',
                              job_title: 'Manager',
                              company: 'Deloitte',
                              language: 'en'
                          })
      client.videos.first.uploaded_videos.create!({provider: 'youtube', provider_id: '1111111'})
      client.videos.first.uploaded_videos.create!({provider: 'vimeo', provider_id: '22222222'})
      get '/api/v1/client/videos', { api_token: reseller.token, client_token: client.token }
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

  context 'POST /api/v1/client/videos/:id/delete' do

    before(:each) do
      client
      client.videos.create!({
                                job_ad_url: 'http://example',
                                job_title: 'Manager',
                                company: 'Deloitte',
                                language: 'en'
                            })
      client.videos.first.uploaded_videos.create!({provider: 'youtube', provider_id: '1111111'})
      client.videos.first.uploaded_videos.create!({provider: 'vimeo', provider_id: '22222222'})
    end

    def do_post
      post '/api/v1/client/videos/'+client.videos.first.id.to_s+'/delete', { api_token: reseller.token, client_token: client.token }
    end

    it 'should return status 200' do
      do_post
      expect(response.status).to eq 200
    end

    it 'should return json with status ok' do
      do_post
      expect(json['status']).to eq 'ok'
    end

    it 'should send delete video email' do
      AdminMailer.should_receive(:delete_video_email)
      do_post
    end
  end


  context 'POST /api/v1/client/videos/:id/edit' do

    before(:each) do
      client
      client.videos.create!({
                                job_ad_url: 'http://example',
                                job_title: 'Manager',
                                company: 'Deloitte',
                                language: 'en'
                            })
      client.videos.first.uploaded_videos.create!({provider: 'youtube', provider_id: '1111111'})
      client.videos.first.uploaded_videos.create!({provider: 'vimeo', provider_id: '22222222'})
    end

    def do_post
      post '/api/v1/client/videos/'+client.videos.first.id.to_s+'/edit', { api_token: reseller.token, client_token: client.token, edit: { comments: 'Some comments' } }
    end

    it 'should return status 200' do
      do_post
      expect(response.status).to eq 200
    end

    it 'should return json with status ok' do
      do_post
      expect(json['status']).to eq 'ok'
    end

    it 'should send edit video email' do
      AdminMailer.should_receive(:edit_video_email)
      do_post
    end

    it 'should create new video edit' do
      expect {
        do_post
      }.to change(client.videos.first.video_edits,:count).by(1)
    end
  end

end
