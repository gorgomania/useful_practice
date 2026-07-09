require "rails_helper"

RSpec.describe Project, type: :model do
  it "can be created" do
    expect { create(:project) }.to change(Project, :count).by(1)
  end
end
