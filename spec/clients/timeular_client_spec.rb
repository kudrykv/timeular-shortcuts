require 'rspec'

describe 'TimeularClient' do
  let(:token) { 'test' }
  let(:bearer) { "Bearer #{token}" }
  let(:domain) { 'https://api.timeular.com/api/v3' }

  let(:tracking_present_str) { file_fixture('current_tracking_present.json').read }
  let(:time_entry_tracking) { TimeEntry.new(JSON.parse(tracking_present_str)['currentTracking']) }

  let(:tracking_url) { "#{domain}/tracking" }

  let(:auth) { double('auth') }
  let(:resp) { double('resp') }
  let(:client) { TimeularClient.new token }

  context 'current tracking' do
    it 'tracks something' do
      allow(HTTP).to receive(:auth).with(bearer).and_return(auth)
      allow(auth).to receive(:get).with(tracking_url).and_return(resp)
      allow(resp).to receive(:body).and_return(tracking_present_str)
      allow(resp).to receive(:status).and_return(200)

      expect(client.current_tracking).to eq(time_entry_tracking)
    end

    it 'tracks nothing' do
      allow(HTTP).to receive(:auth).with(bearer).and_return(auth)
      allow(auth).to receive(:get).with(tracking_url).and_return(resp)
      allow(resp).to receive(:body).and_return(file_fixture('current_tracking_absent.json').read)
      allow(resp).to receive(:status).and_return(200)

      expect(client.current_tracking).to be_nil
    end
  end
end