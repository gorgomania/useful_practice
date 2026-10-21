require "rails_helper"

RSpec.describe UserPolicy, type: :policy do
  let(:user) { create(:user) }

  describe "#index?" do
    it "is allowed for any user" do
      expect(described_class.new(user, user).index?).to be true
    end
  end
end
