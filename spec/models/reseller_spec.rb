require 'spec_helper'

describe Reseller do
  let(:reseller) { Reseller.create(name: 'test name', language: 'en') }

  context 'slug' do
    it 'should create slug on reseller creation' do
      expect(reseller.slug).to be_present
    end

    it 'slug shoud consist of lowercase letters and numbers' do
      expect(reseller.slug).to match /^[a-z0-9]+$/
    end
  end

  context 'token' do
    it 'should create token on creation' do
      expect(reseller.token).to be_present
    end
  end

end
