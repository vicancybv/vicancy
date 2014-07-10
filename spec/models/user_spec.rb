require 'spec_helper'

describe User do
  context 'slug creation' do
    it "generates a slug automatically if none is provided" do
      @user = User.create
      @user.slug.should_not be_blank
      @user.slug.size.should == 8
    end

    it "should not override an existing slug" do
      @user = User.create(slug: 'wibble')
      @user.slug.should == 'wibble'
    end
  end

  context 'token creation' do
    let(:user) { User.create }

    it 'generates a token automatically if none is provided' do
      expect(user.token).not_to be_blank
    end

    it 'generated token size is >= 16 symbols' do
      expect(user.token.size).to be >= 16
    end

    it 'should not override an existing slug' do
      user = User.create(token: 'sometoken')
      expect(user.token).to eq 'sometoken'
    end

    it 'should not allow creation of users with the same token' do
      User.create(token: 'sometoken')
      expect {
        User.create(token: 'sometoken')
      }.to raise_error
    end
  end
end
