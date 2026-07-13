require "rails_helper"

RSpec.describe Project, type: :model do
  describe "validations" do
    it "can be created with valid attributes" do
      expect { create(:project) }.to change(Project, :count).by(1)
    end

    it "is invalid without a name" do
      project = build(:project, name: "")
      expect(project).not_to be_valid
    end

    it "is invalid with duplicate name for the same user" do
      user = create(:user)
      create(:project, name: "hegemon", user: user)
      duplicate = build(:project, name: "hegemon", user: user)
      expect(duplicate).not_to be_valid
    end

    it "allows same name for different users" do
      create(:project, name: "hegemon")
      other = build(:project, name: "hegemon")
      expect(other).to be_valid
    end
  end

  describe "associations" do
    it "belongs to user" do
      project = create(:project)
      expect(project.user).to be_a(User)
    end

    it "destroys tasks when destroyed" do
      project = create(:project)
      create(:task, project: project)
      expect { project.destroy }.to change(Task, :count).by(-1)
    end
  end

  describe "#tasks_by_state" do
    let(:project) { create(:project) }

    it "returns empty array when no tasks" do
      expect(project.tasks_by_state).to eq([])
    end

    it "returns tasks interleaved by state columns" do
      todo = create(:task, project: project)
      project.tasks_by_state.tap do |result|
        expect(result).to include(todo)
      end
    end

    it "includes nils for empty columns" do
      create(:task, project: project)
      result = project.tasks_by_state
      expect(result.size).to eq(Project::STATE_KEYS.size)
      expect(result).to include(nil)
    end
  end
end
