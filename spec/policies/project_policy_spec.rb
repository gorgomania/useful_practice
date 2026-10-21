require "rails_helper"

RSpec.describe ProjectPolicy, type: :policy do
  let(:user)        { create(:user) }
  let(:other_user)  { create(:user) }
  let(:own_project) { create(:project, user: user) }
  let(:other_project) { create(:project, user: other_user) }

  describe "#index?" do
    it "is allowed for any user" do
      expect(described_class.new(user, own_project).index?).to be true
    end
  end

  describe "#create?" do
    it "is allowed for any user" do
      expect(described_class.new(user, Project.new).create?).to be true
    end
  end

  describe "#show?" do
    it "is allowed for the owner" do
      expect(described_class.new(user, own_project).show?).to be true
    end

    it "is denied for a non-owner" do
      expect(described_class.new(user, other_project).show?).to be false
    end
  end

  describe "#edit? / #update?" do
    it "is allowed for the owner" do
      expect(described_class.new(user, own_project).edit?).to be true
      expect(described_class.new(user, own_project).update?).to be true
    end

    it "is denied for a non-owner" do
      expect(described_class.new(user, other_project).edit?).to be false
      expect(described_class.new(user, other_project).update?).to be false
    end
  end

  describe "#destroy?" do
    it "is allowed for the owner" do
      expect(described_class.new(user, own_project).destroy?).to be true
    end

    it "is denied for a non-owner" do
      expect(described_class.new(user, other_project).destroy?).to be false
    end
  end

  describe "Scope" do
    it "returns only projects belonging to the current user" do
      own_project
      other_project
      scope = described_class::Scope.new(user, Project.all).resolve
      expect(scope).to include(own_project)
      expect(scope).not_to include(other_project)
    end
  end
end
