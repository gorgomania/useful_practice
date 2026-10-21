require "rails_helper"

RSpec.describe UsersController, type: :controller do
  describe "GET #index" do
    context "when user is not logged in" do
      it "redirects to login page" do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is logged in" do
      let(:user) { create(:user) }
      before { sign_in user }

      it "renders index template" do
        get :index
        expect(response).to render_template(:index)
      end
    end
  end
end
