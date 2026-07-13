require "rails_helper"

RSpec.describe Task, type: :model do
  describe "validations" do
    it "can be created with valid attributes" do
      expect { create(:task) }.to change(Task, :count).by(1)
    end

    it "is invalid without a name" do
      task = build(:task, name: "")
      expect(task).not_to be_valid
    end

    it "is invalid with duplicate name in the same project" do
      project = create(:project)
      create(:task, name: "hegemon", project: project)
      duplicate = build(:task, name: "hegemon", project: project)
      expect(duplicate).not_to be_valid
    end

    it "allows same name in different projects" do
      create(:task, name: "hegemon")
      other = build(:task, name: "hegemon")
      expect(other).to be_valid
    end
  end

  describe "associations" do
    it "belongs to project" do
      task = create(:task)
      expect(task.project).to be_a(Project)
    end
  end

  describe "state machine" do
    let(:task) { create(:task) }

    it "starts in ToDo state" do
      expect(task.state).to eq("ToDo")
    end

    it "transitions from ToDo to InProgress" do
      task.inprogress
      expect(task.state).to eq("InProgress")
    end

    it "transitions from InProgress to InTesting" do
      task.inprogress
      task.intesting
      expect(task.state).to eq("InTesting")
    end

    it "transitions from InProgress to ToDo" do
      task.inprogress
      task.todo
      expect(task.state).to eq("ToDo")
    end

    it "transitions from InTesting to Done" do
      task.inprogress
      task.intesting
      task.done
      expect(task.state).to eq("Done")
    end

    it "transitions from InTesting to Rejected" do
      task.inprogress
      task.intesting
      task.rejected
      expect(task.state).to eq("Rejected")
    end

    it "transitions from Rejected to InProgress" do
      task.inprogress
      task.intesting
      task.rejected
      task.inprogress
      expect(task.state).to eq("InProgress")
    end
  end
end
