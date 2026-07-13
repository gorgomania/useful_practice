require "rails_helper"

RSpec.describe TasksController, type: :controller do
  describe "GET #new" do
    context "when user is not logged in" do
      it "redirects to login page" do
        get :new, params: { project_id: 1 }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when project does not exist" do
      let(:user) { create(:user) }
      before { sign_in user }

      it "renders 404" do
        get :new, params: { project_id: 0 }
        expect(response).to render_template("application/errors/404")
      end
    end

    context "when project belongs to another user" do
      let(:user) { create(:user) }
      let!(:other_project) { create(:project) }
      before { sign_in user }

      it "renders 404" do
        get :new, params: { project_id: other_project.id }
        expect(response).to render_template("application/errors/404")
      end
    end

    context "when project belongs to current user" do
      let(:user) { create(:user) }
      let!(:project) { create(:project, user: user) }
      before { sign_in user }

      it "renders new template" do
        get :new, params: { project_id: project.id }
        expect(response).to render_template(:new)
      end
    end
  end

  describe "POST #create" do
    context "when project does not exist" do
      let(:user) { create(:user) }
      before { sign_in user }

      it "renders 404" do
        post :create, params: { project_id: 0, tasks: { name: "hegemon" } }
        expect(response).to render_template("application/errors/404")
      end
    end

    context "when project belongs to another user" do
      let(:user) { create(:user) }
      let!(:other_project) { create(:project) }
      before { sign_in user }

      it "renders 404" do
        post :create, params: { project_id: other_project.id, tasks: { name: "hegemon" } }
        expect(response).to render_template("application/errors/404")
      end
    end

    context "when project belongs to current user" do
      let(:user) { create(:user) }
      let!(:project) { create(:project, user: user) }
      before { sign_in user }

      context "with empty name" do
        it "renders new template" do
          post :create, params: { project_id: project.id, tasks: { name: "" } }
          expect(response).to render_template(:new)
        end

        it "does not create task" do
          expect {
            post :create, params: { project_id: project.id, tasks: { name: "" } }
          }.not_to change(Task, :count)
        end
      end

      context "with valid name" do
        it "redirects to project" do
          post :create, params: { project_id: project.id, tasks: { name: "hegemon" } }
          expect(response).to redirect_to(project_path(project.id))
        end

        it "creates a task" do
          expect {
            post :create, params: { project_id: project.id, tasks: { name: "hegemon" } }
          }.to change(Task, :count).by(1)
        end
      end
    end
  end

  describe "GET #edit" do
    let(:user) { create(:user) }
    before { sign_in user }

    context "when project does not exist" do
      it "renders 404" do
        get :edit, params: { project_id: 0, id: 1 }
        expect(response).to render_template("application/errors/404")
      end
    end

    context "when project belongs to another user" do
      let!(:other_project) { create(:project) }
      let!(:task) { create(:task, project: other_project) }

      it "renders 404" do
        get :edit, params: { project_id: other_project.id, id: task.id }
        expect(response).to render_template("application/errors/404")
      end
    end

    context "when project belongs to current user" do
      let!(:project) { create(:project, user: user) }

      context "when task does not exist" do
        it "renders 404" do
          get :edit, params: { project_id: project.id, id: 0 }
          expect(response).to render_template("application/errors/404")
        end
      end

      context "when task exists" do
        let!(:task) { create(:task, project: project) }

        it "renders edit template" do
          get :edit, params: { project_id: project.id, id: task.id }
          expect(response).to render_template(:edit)
        end
      end
    end
  end

  describe "PATCH #update" do
    let(:user) { create(:user) }
    before { sign_in user }

    context "when project does not exist" do
      it "renders 404" do
        patch :update, params: { project_id: 0, id: 1, tasks: { name: "hegemon" } }
        expect(response).to render_template("application/errors/404")
      end
    end

    context "when project belongs to another user" do
      let!(:other_project) { create(:project) }
      let!(:task) { create(:task, project: other_project) }

      it "renders 404" do
        patch :update, params: { project_id: other_project.id, id: task.id, tasks: { name: "hegemon" } }
        expect(response).to render_template("application/errors/404")
      end
    end

    context "when project belongs to current user" do
      let!(:project) { create(:project, user: user) }
      let!(:task) { create(:task, project: project) }

      context "when task does not exist" do
        it "renders 404" do
          patch :update, params: { project_id: project.id, id: 0, tasks: { name: "hegemon" } }
          expect(response).to render_template("application/errors/404")
        end
      end

      context "with empty name" do
        it "renders edit template" do
          patch :update, params: { project_id: project.id, id: task.id, tasks: { name: "", state: "To Do" } }
          expect(response).to render_template(:edit)
        end
      end

      context "with invalid state" do
        it "renders edit template" do
          patch :update, params: { project_id: project.id, id: task.id, tasks: { name: "hegemon", state: nil } }
          expect(response).to render_template(:edit)
        end
      end

      context "with valid params" do
        it "redirects to project" do
          patch :update, params: { project_id: project.id, id: task.id, tasks: { name: "hegemon", state: "In Progress" } }
          expect(response).to redirect_to(project_path(project.id))
        end

        it "updates task name" do
          patch :update, params: { project_id: project.id, id: task.id, tasks: { name: "hegemon", state: "In Progress" } }
          expect(task.reload.name).to eq("hegemon")
        end

        it "updates task state" do
          patch :update, params: { project_id: project.id, id: task.id, tasks: { name: task.name, state: "In Progress" } }
          expect(task.reload.state).to eq("InProgress")
        end
      end
    end
  end

  describe "DELETE #destroy" do
    let(:user) { create(:user) }
    before { sign_in user }

    context "when project does not exist" do
      it "renders 404" do
        delete :destroy, params: { project_id: 0, id: 1 }
        expect(response).to render_template("application/errors/404")
      end
    end

    context "when project belongs to another user" do
      let!(:other_project) { create(:project) }
      let!(:task) { create(:task, project: other_project) }

      it "renders 404" do
        delete :destroy, params: { project_id: other_project.id, id: task.id }
        expect(response).to render_template("application/errors/404")
      end
    end

    context "when project belongs to current user" do
      let!(:project) { create(:project, user: user) }

      context "when task does not exist" do
        it "renders 404" do
          delete :destroy, params: { project_id: project.id, id: 0 }
          expect(response).to render_template("application/errors/404")
        end
      end

      context "when task exists" do
        let!(:task) { create(:task, project: project) }

        it "redirects to project" do
          delete :destroy, params: { project_id: project.id, id: task.id }
          expect(response).to redirect_to(project_path(project.id))
        end

        it "deletes the task" do
          expect {
            delete :destroy, params: { project_id: project.id, id: task.id }
          }.to change(Task, :count).by(-1)
        end
      end
    end
  end
end
