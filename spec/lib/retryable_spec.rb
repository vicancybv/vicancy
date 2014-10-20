require 'spec_helper'

describe Retryable do
  let(:helper) { Object.new }
  let(:runner) { Object.new }
  before(:each) do
    Rollbar.stub(:report_message)
    helper.extend Retryable
    def runner.run(should_raise=nil)
      if should_raise
        raise 'Exception'
      else
        'Aa'
      end
    end
  end

  context 'self-test' do
    it 'runner should return Aa' do
      expect(runner.run).to eq 'Aa'
    end
  end

  context 'no exception' do
    it 'should return runner result' do
      expect(helper.try_n_times(3) { runner.run }).to eq 'Aa'
    end

    it 'should call runner 1 time' do
      runner.should_receive(:run).once
      helper.try_n_times(3) { runner.run }
    end
  end

  context 'with exception' do
    let(:except2) { Object.new }
    let(:except3) { Object.new }
    before(:each) do
      except2.stub(:now?).and_return(true, true, false)
      except3.stub(:now?).and_return(true, true, true)
    end

    it 'should return exception with 3 consecutive exceptions' do
      expect{ helper.try_n_times(3) { runner.run(except3.now?) } }.to raise_error 'Exception'
    end

    it 'should call runner 3 times with 3 consecutive exceptions' do
      runner.should_receive(:run).exactly(3).times.and_call_original
      expect{ helper.try_n_times(3) { runner.run(except3.now?) } }.to raise_error 'Exception'
    end

    it 'should return runner result with 2 consecutive exceptions' do
      expect(helper.try_n_times(3) { runner.run(except2.now?) }).to eq 'Aa'
    end

    it 'should call runner 3 times with 2 consecutive exceptions' do
      runner.should_receive(:run).exactly(3).times.and_call_original
      expect(helper.try_n_times(3) { runner.run(except2.now?) }).to eq 'Aa'
    end

    it 'should message rollbar 2 times with 2 consecutive exceptions' do
      Rollbar.should_receive(:report_message).twice
      expect(helper.try_n_times(3) { runner.run(except2.now?) }).to eq 'Aa'
    end
  end

end