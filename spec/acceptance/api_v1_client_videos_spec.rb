require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Client API' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let(:json) { JSON::parse(response_body) }

  get '/api/v1/client/videos' do
    parameter :api_token, 'Reseller\'s unique API Token', :required => true
    parameter :client_token, 'Client\'s Auth Token' , :required => true

    let(:reseller) { create(:reseller, token: 'r5CvvP2hP9fIPRqUmcGzSw') }
    let(:c) { reseller.clients.create!(attributes_for(:client, external_id: '3132', name: 'Deloitte', email: 'deloitte@example.com', language: 'en', token: '_FueOIO5cR7XKtfgjcb6pA')) }
    let(:params) {
      ({
          api_token: reseller.token,
          client_token: c.token
      })
    }

    example 'List videos' do
      c.videos.create!(attributes_for(:video))
      c.videos.create!(attributes_for(:video))

      explanation 'List client videos'

      do_request

      puts json
      status.should == 200
    end
  end
end