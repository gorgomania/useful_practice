require "rails_helper"

RSpec.describe TaskPolicy, type: :policy do
  let(:user)       { create(:user) }
  let(:other_user) { create(:user) }
  let(:own_project)   { create(:project, user: user) }
  let(:other_project) { create(:project, user: other_user) }
  let(:own_task)   { create(:task, project: own_project) }
  let(:other_task) { create(:task, project: other_project) }

  %i[show? create? update? destroy?].each do |action|
    describe "##{action}" do
      it "is allowed when the current user owns the project" do
        expect(described_class.new(user, own_task).public_send(action)).to be true
      end

      it "is denied when the project belongs to another user" do
        expect(described_class.new(user, other_task).public_send(action)).to be false
      end
    end
  end
end
