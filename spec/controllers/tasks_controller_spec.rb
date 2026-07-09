require "rails_helper"

RSpec.describe TasksController, type: :controller do
  describe "GET #new" do
        subject { get :new, params: { project_id: 1 } }
        context "when user is not logged in" do
            it "redirects to login page" do
                subject
                expect(response).to redirect_to(new_user_session_path)
            end
        end
        context "when user is logged in and project is not created" do
            let(:user) { create(:user) }
            before { sign_in user }
            it "returns a success response" do
                subject
                expect(response).to render_template("application/errors/404")
            end
        end
        context "when user is logged in and project is created" do
            let(:user) { create(:user) }
            let!(:project) { create(:project, user: user) }
            subject { get :new, params: { project_id: project.id } }
            before { sign_in user }
            it "returns a success response" do
                subject
                expect(response).to render_template(:new)
            end
        end
    end
    describe "GET #show" do
        subject { get :show, params: { project_id: 1, id: 1 } }
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
                expect(response).to redirect_to(project_path(1))
            end
        end
    end

    describe "POST #create" do
        context "project is not created" do
            subject { post :create, params: { project_id: 2, tasks: { name: "" } } }
            let(:user) { create(:user) }
            before { sign_in user }
            it "task is not created" do
                subject
                expect(response).to render_template("application/errors/404")
            end
        end
        context "project is created and task is created with empty name" do
          let(:user) { create(:user) }
          let!(:project) { create(:project, user: user) }
          subject { post :create, params: { project_id: project.id, tasks: { name: "" } } }
          before { sign_in user }
          it "task is not created" do
              subject
              expect(response).to render_template(:new)
          end
        end
        context "project is created and task is created with correct name" do
            let(:user) { create(:user) }
            let!(:project) { create(:project, user: user) }
            subject { post :create, params: { project_id: project.id, tasks: { name: "hegemon" } } }
            before { sign_in user }
            it "task is created" do
                subject
                expect(response).to redirect_to(project_path(project.id))
            end
        end
    end

    describe "GET #edit" do
        context "project is not created" do
            subject { get :edit, params: { project_id: 4, id: 1 } }
            let(:user) { create(:user) }
            before { sign_in user }
            it "render 404 error template" do
                subject
                expect(response).to render_template("application/errors/404")
            end
        end
        context "project is created and task is not created" do
          let(:user) { create(:user) }
          let!(:project) { create(:project, user: user) }
          subject { get :edit, params: { project_id: project.id, id: 1 } }
          before { sign_in user }
          it "render 404 error template" do
              subject
              expect(response).to render_template("application/errors/404")
          end
        end
        context "project is created and task is created" do
            let(:user) { create(:user) }
            let!(:project) { create(:project, user: user) }
            let!(:task) { create(:task, project: project) }
            subject { get :edit, params: { project_id: project.id, id: task.id } }
            before { sign_in user }
            it "render edit template" do
                subject
                expect(response).to render_template(:edit)
            end
        end
    end

     describe "PATCH #update" do
        context "project is not created" do
            subject { patch :update, params: { project_id: 6, id: 3, tasks: { name: "hegemon" } } }
            let(:user) { create(:user) }
            before { sign_in user }
            it "render 404 error template" do
                subject
                expect(response).to render_template("application/errors/404")
            end
        end
        context "project is created and task is not created" do
          let(:user) { create(:user) }
          let!(:project) { create(:project, user: user) }
          subject { patch :update, params: { project_id: project.id, id: 3, tasks: { name: "hegemon" } } }
          before { sign_in user }
          it "render 404 error template" do
              subject
              expect(response).to render_template("application/errors/404")
          end
        end
        context "project is created and task is created, updated date is incorrect" do
            let(:user) { create(:user) }
            let!(:project) { create(:project, user: user) }
            let!(:task) { create(:task, project: project) }
            subject { patch :update, params: { project_id: project.id, id: task.id, tasks: { name: "hegemon" } } }
            before { sign_in user }
            it "render edit template" do
                subject
                expect(response).to render_template(:edit)
            end
        end
        context "project is created and task is created, updated date is correct" do
            let(:user) { create(:user) }
            let!(:project) { create(:project, user: user) }
            let!(:task) { create(:task, project: project) }
            subject { patch :update, params: { project_id: project.id, id: task.id, tasks: { name: "hegemon", state: "In Progress" } } }
            before { sign_in user }
            it "redirect to project path" do
                subject
                expect(response).to redirect_to(project_path(project.id))
            end
        end
    end
     describe "DELETE #destroy" do
        context "project is not created" do
            subject { delete :destroy, params: { project_id: 9, id: 5 } }
            let(:user) { create(:user) }
            before { sign_in user }
            it "render 404 error template" do
                subject
                expect(response).to render_template("application/errors/404")
            end
        end
        context "project is created and task is not created" do
          let(:user) { create(:user) }
          let!(:project) { create(:project, user: user) }
          subject { delete :destroy, params: { project_id: project.id, id: 5 } }
          before { sign_in user }
          it "redirect to project path" do
              subject
              expect(response).to redirect_to(project_path(project.id))
          end
        end
        context "project is created and task is created" do
            let(:user) { create(:user) }
            let!(:project) { create(:project, user: user) }
            let!(:task) { create(:task, project: project) }
            subject { delete :destroy, params: { project_id: project.id, id: task.id } }
            before { sign_in user }
            it "redirect to project path" do
                subject
                expect(response).to redirect_to(project_path(project.id))
            end
        end
    end
end
