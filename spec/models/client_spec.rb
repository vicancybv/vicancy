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
