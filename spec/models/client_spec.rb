require 'spec_helper'

describe Client do
  let(:client) { Client.create(name: 'test name', language: 'en') }

  context 'slug' do
    it 'should create slug on creation' do
      expect(client.slug).to be_present
    end

    it 'slug shoud consist of lowercase letters and numbers' do
      expect(client.slug).to match /^[a-z0-9]+$/
    end
  end

  context 'token' do
    it 'should create token on creation' do
      expect(client.token).to be_present
    end
  end
end

describe Client, 'fetch' do
  let(:reseller) { create(:reseller) }

  let(:attrs) { ({
      external_id: '1234',
      name: 'Client name',
      email: 'name@example.com',
      language: 'en'
  })
  }

  context 'new user' do
    it 'should create user' do
      expect {
        Client.fetch(reseller, attrs)
      }.to change(Client, :count).by(1)
    end

    it 'should create user with correct attributes' do
      client = Client.fetch(reseller, attrs)
      expect(client.external_id).to eq '1234'
      expect(client.name).to eq 'Client name'
      expect(client.email).to eq 'name@example.com'
      expect(client.language).to eq 'en'
    end

    it 'should raise error when no external id' do
      attrs[:external_id] = nil
      expect {
        Client.fetch(reseller, attrs)
      }.to raise_error 'Need to provide external_id'
    end

    it 'should raise error when no name' do
      attrs[:name] = ''
      expect {
        Client.fetch(reseller, attrs)
      }.to raise_error 'Need to provide name'
    end

    it 'should create client without email' do
      attrs[:email] = nil
      expect {
        Client.fetch(reseller, attrs)
      }.to change(Client, :count).by(1)
    end

    it 'should create client without language' do
      attrs[:language] = nil
      expect {
        Client.fetch(reseller, attrs)
      }.to change(Client, :count).by(1)
    end
  end

  context 'user exists' do
    let(:ex_client) { create(:client, reseller: reseller, external_id: attrs[:external_id], name: attrs[:name],
                          email: attrs[:email], language: attrs[:language]) }

    before(:each) do
      ex_client
    end

    it 'should not create when client already exists' do
      expect {
        Client.fetch(reseller, attrs)
      }.not_to change(Client, :count)
    end

    it 'should return existing client' do
      expect(Client.fetch(reseller, attrs).id).to eq ex_client.id
    end

    it 'should return existing client with correct fields' do
      client = Client.fetch(reseller, attrs)
      expect(client.external_id).to eq '1234'
      expect(client.name).to eq 'Client name'
      expect(client.email).to eq 'name@example.com'
      expect(client.language).to eq 'en'
    end

    it 'should update existing client when name is different' do
      attrs[:name] = 'new'
      Client.fetch(reseller, attrs)
      ex_client.reload
      expect(ex_client.name).to eq 'new'
    end

    it 'should update existing client when email is different' do
      attrs[:email] = 'new'
      Client.fetch(reseller, attrs)
      ex_client.reload
      expect(ex_client.email).to eq 'new'
    end

    it 'should update existing client when language is different' do
      attrs[:language] = 'nl'
      Client.fetch(reseller, attrs)
      ex_client.reload
      expect(ex_client.language).to eq 'nl'
    end
  end
end
