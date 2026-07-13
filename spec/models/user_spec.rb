require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    it "can be created with valid attributes" do
      expect { create(:user) }.to change(User, :count).by(1)
    end

    it "is invalid without email" do
      user = build(:user, email: "")
      expect(user).not_to be_valid
    end

    it "is invalid with duplicate email" do
      create(:user, email: "test@example.com")
      duplicate = build(:user, email: "test@example.com")
      expect(duplicate).not_to be_valid
    end

    it "is invalid without password" do
      user = build(:user, password: "", password_confirmation: "")
      expect(user).not_to be_valid
    end
  end

  describe "associations" do
    it "destroys projects when destroyed" do
      user = create(:user)
      create(:project, user: user)
      expect { user.destroy }.to change(Project, :count).by(-1)
    end
  end
end
