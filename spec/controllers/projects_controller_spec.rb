require "rails_helper"

RSpec.describe ProjectsController, type: :controller do
    describe "GET #index" do
        subject { get :index }
        context "when user is not logged in" do
            it "redirects to login page" do
                subject
                expect(response).to redirect_to(new_user_session_path)
            end
        end
        context "when user is logged in" do
            let(:user) { create(:user) }
            before { sign_in user }
            it "returns a success response" do
                subject
                expect(response).to render_template(:index)
            end
        end
    end
    describe "GET #show" do
        context "when project is not created" do
            subject { get :show, params: { id: 1 } }
            let(:user) { create(:user) }
            before { sign_in user }
            it "redirects to 404 error page" do
                subject
                expect(response).to render_template("application/errors/404")
            end
        end
        context "when project is created" do
            let(:user) { create(:user) }
            let!(:project) { create(:project, user: user) }
            subject { get :show, params: { id: project.id } }
            before { sign_in user }
            it "renders a show template" do
                subject
                expect(response).to render_template(:show)
            end
        end
    end
    describe "GET #new" do
        subject { get :new }
        context "when user is not logged in" do
            it "redirects to login page" do
                subject
                expect(response).to redirect_to(new_user_session_path)
            end
        end
        context "when user is logged in" do
            let(:user) { create(:user) }
            before { sign_in user }
            it "returns a success response" do
                subject
                expect(response).to render_template(:new)
            end
        end
    end
    describe "POST #create" do
        context "project is created with empty name" do
            subject { post :create, params: { projects: { name: "", goal: "", description: "" } } }
            let(:user) { create(:user) }
            before { sign_in user }
            it "project is not created" do
                subject
                expect(response).to render_template(:new)
            end
        end
        context "project is created with correct name" do
            subject { post :create, params: { projects: { name: "hegemon", goal: "", description: "" } } }
            let(:user) { create(:user) }
            before { sign_in user }
            it "project is created" do
                subject
                expect(response).to redirect_to(projects_path)
            end
        end
    end
end
