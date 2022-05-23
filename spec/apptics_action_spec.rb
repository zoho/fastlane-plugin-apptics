describe Fastlane::Actions::AppticsAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The apptics plugin is working!")
      Fastlane::Actions::AppticsAction.run(nil)
    end
  end
end
