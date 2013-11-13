require 'spec_helper'

describe Video do

  context 'with a Vimeo and YouTube ID' do

    before(:each) do
      @video = Video.create(language: "en", vimeo_id:'12345', youtube_id:'abcde')
    end

    it 'should return a Vimeo URL' do
      @video.video_url.should == "http://vimeo.com/12345"
    end

    it 'should return a Vimeo embed URL' do
      @video.embed_url.should == "http://player.vimeo.com/video/12345"
    end

  end

  context 'with a YouTube ID only' do

    before(:each) do
      @video = Video.create(language: "en", youtube_id:'abcde')
    end

    it 'should return a YouTube URL' do
      @video.video_url.should == "http://www.youtube.com/watch?v=abcde"
    end

    it 'should return a YouTube embed URL' do
      @video.embed_url.should == "http://www.youtube.com/embed/abcde"
    end

  end

end