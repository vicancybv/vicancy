require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Client API' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let(:json) { JSON::parse(response_body) }

  post '/api/v1/client/auth' do
    parameter :api_token, 'Reseller\'s unique API Token', :required => true
    parameter :id, 'Client\'s unique identifier in Reseller\' system (can be number or text)' , :required => true, :scope => :client
    parameter :name, 'Client name' , :required => true, :scope => :client
    parameter :email, 'Client email' , :required => false, :scope => :client
    parameter :language, 'In which language to show widget (e.g. en, es, nl)' , :required => false, :scope => :client

    let(:reseller) { create(:reseller, token: 'r5CvvP2hP9fIPRqUmcGzSw') }
    let(:c) { reseller.clients.create!(attributes_for(:client, external_id: '3132', name: 'Deloitte', email: 'deloitte@example.com', language: 'en', token: '_FueOIO5cR7XKtfgjcb6pA')) }
    let(:raw_post) {
      ({
          api_token: reseller.token,
          client: {
              id: c.external_id,
              name: c.name,
              email: c.email,
              language: c.language
          }
      }).to_json
    }

    example 'Authenticate client' do
      explanation 'Authenticates client using reseller\'s API Token.
Creates client if not present.
Updates if name/email/language changed.
Returns client token.'

      do_request

      puts json
      status.should == 200
    end
  end
end