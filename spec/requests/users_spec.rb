require "rails_helper"

RSpec.describe "Users", type: :request do
  describe "GET /users" do
    context "when user is not logged in" do
      it "redirects to login page" do
        get users_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is logged in" do
      let(:user) { create(:user) }
      before { sign_in user }

      it "renders the profile page" do
        get users_path
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Профиль", user.email)
      end
    end
  end
end
