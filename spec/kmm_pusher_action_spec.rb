describe Fastlane::Actions::KmmPusherAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The kmm_pusher plugin is working!")

      Fastlane::Actions::KmmPusherAction.run(nil)
    end
  end
end
