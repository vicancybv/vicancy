require 'spec_helper'

describe User do
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
