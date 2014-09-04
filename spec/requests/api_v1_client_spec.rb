require 'spec_helper'

describe '/api/v1/client' do

  context '/api/v1/client/auth' do
    let(:json) { JSON.parse(response.body) }
    let(:reseller) { create(:reseller) }
    let(:client) { create(:client, reseller: reseller) }
    let(:api_token) { reseller.token }

    context 'client exists' do
      let(:params) do
        ({ api_token: api_token,
           client: {
               id: client.external_id,
               name: client.name,
               email: client.email
           } })
      end

      after(:each) do
        expect(response.status).to eq 200
        expect(json['status']).to eq 'ok'
      end

      it 'should return client token' do
        post_json '/api/v1/client/auth', params
        expect(json['client_token']).to eq client.token
      end

    end

    context 'client exists, different info' do
      let(:reseller) { create(:reseller) }
      let(:client) { create(:client, reseller: reseller) }
      let(:api_token) { reseller.token }
      let(:params) do
        ({ api_token: api_token,
           client: {
               id: client.external_id,
               name: 'new name',
               email: 'new email',
               language: 'nl'
           } })
      end

      after(:each) do
        expect(response.status).to eq 200
        expect(json['status']).to eq 'ok'
      end

      it 'should return client token' do
        post_json '/api/v1/client/auth', params
        expect(json['client_token']).to eq client.token
      end

      it 'client info should be updated' do
        post_json '/api/v1/client/auth', params
        client.reload
        expect(client.name).to eq 'new name'
        expect(client.email).to eq 'new email'
        expect(client.language).to eq 'nl'
      end

      it 'should not update slug field' do
        params = { api_token: api_token, client: { id: client.external_id, slug: 'new slug' } }
        expect {
          post_json '/api/v1/client/auth', params
          client.reload
        }.not_to change { client.slug }
      end

      it 'should not update token field' do
        params = { api_token: api_token, client: { id: client.external_id, token: 'new token' } }
        expect {
          post_json '/api/v1/client/auth', params
          client.reload
        }.not_to change { client.token }
      end
    end

    context 'client from different reseller' do
      let(:reseller2) { create(:reseller2) }
      let(:client2) { reseller2.clients.create({ name: 'New one', email: 'some', external_id: 'someid' }) }
      let(:params) do
        ({ api_token: api_token,
           client: {
               id: client2.external_id,
               name: client2.name,
               email: client2.email,
               external_id: client2.external_id
           }
        })
      end

      after(:each) do
        expect(response.status).to eq 200
        expect(json['status']).to eq 'ok'
      end

      it 'should create new client' do
        client2 # create it so it doesn't affect Client.count
        expect {
          post_json '/api/v1/client/auth', params
        }.to change { Client.count }.by(1)
      end
    end

    context 'unknown reseller token' do
      let(:api_token) { 'unknown token' }
      let(:params) { ({ api_token: api_token }) }

      after(:each) do
        expect(response.status).to eq 401
        expect(json['status']).to eq 'error'
      end

      it 'should return error text' do
        post_json '/api/v1/client/auth', params
        expect(json['error_text']).to include 'Unknown reseller'
      end
    end

    context 'client not exists' do
      let(:params) do
        ({ api_token: api_token,
           client: {
               id: 'new id',
               name: 'Deloitte',
               email: 'deloitte@example.com',
               language: 'en'
           } })
      end

      after(:each) do
        expect(response.status).to eq 200
        expect(json['status']).to eq 'ok'
      end

      it 'should create new client' do
        expect {
          post_json '/api/v1/client/auth', params
        }.to change { Client.count }.by(1)
      end

      it 'should return client token' do
        post_json '/api/v1/client/auth', params
        expect(json['client_token']).not_to be_blank
      end

      it 'should be able to find client by token' do
        post_json '/api/v1/client/auth', params
        client = Client.find_by_token!(json['client_token'])
        expect(client).not_to be_blank
      end

      it 'should save client with correct params' do
        post_json '/api/v1/client/auth', params
        client = Client.find_by_token!(json['client_token'])
        expect(client.reseller_id).to eq reseller.id
        expect(client.name).to eq 'Deloitte'
        expect(client.email).to eq 'deloitte@example.com'
        expect(client.language).to eq 'en'
        expect(client.external_id).to eq 'new id'
      end

    end
  end

end
