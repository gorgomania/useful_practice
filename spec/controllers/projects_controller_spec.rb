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

      it "renders index template" do
        subject
        expect(response).to render_template(:index)
      end

      it "returns only current user projects" do
        own_project = create(:project, user: user)
        other_project = create(:project)
        subject
        expect(assigns(:projects)).to include(own_project)
        expect(assigns(:projects)).not_to include(other_project)
      end

      context "with search query" do
        let!(:matching) { create(:project, name: "hegemon", user: user) }
        let!(:other) { create(:project, name: "something_else", user: user) }

        it "filters projects by name" do
          get :index, params: { projects: { name: "hegemon" } }
          expect(assigns(:projects)).to include(matching)
          expect(assigns(:projects)).not_to include(other)
        end
      end
    end
  end

  describe "GET #show" do
    context "when project does not exist" do
      let(:user) { create(:user) }
      before { sign_in user }

      it "renders 404" do
        get :show, params: { id: 0 }
        expect(response).to render_template("application/errors/404")
      end
    end

    context "when project belongs to another user" do
      let(:user) { create(:user) }
      let(:other_project) { create(:project) }
      before { sign_in user }

      it "redirects with alert" do
        get :show, params: { id: other_project.id }
        expect(response).to redirect_to(root_path)
      end
    end

    context "when project belongs to current user" do
      let(:user) { create(:user) }
      let!(:project) { create(:project, user: user) }
      before { sign_in user }

      it "renders show template" do
        get :show, params: { id: project.id }
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

      it "renders new template" do
        subject
        expect(response).to render_template(:new)
      end
    end
  end

  describe "POST #create" do
    let(:user) { create(:user) }
    before { sign_in user }

    context "with empty name" do
      subject { post :create, params: { projects: { name: "", goal: "", description: "" } } }

      it "renders new template" do
        subject
        expect(response).to render_template(:new)
      end

      it "does not create project" do
        expect { subject }.not_to change(Project, :count)
      end
    end

    context "with valid params" do
      subject { post :create, params: { projects: { name: "hegemon", goal: "", description: "" } } }

      it "redirects to projects path" do
        subject
        expect(response).to redirect_to(projects_path)
      end

      it "creates a project" do
        expect { subject }.to change(Project, :count).by(1)
      end
    end

    context "with duplicate name" do
      let!(:existing) { create(:project, name: "hegemon", user: user) }
      subject { post :create, params: { projects: { name: "hegemon", goal: "", description: "" } } }

      it "renders new template" do
        subject
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET #edit" do
    let(:user) { create(:user) }
    before { sign_in user }

    context "when project does not exist" do
      it "renders 404" do
        get :edit, params: { id: 0 }
        expect(response).to render_template("application/errors/404")
      end
    end

    context "when project belongs to another user" do
      let(:other_project) { create(:project) }

      it "redirects with alert" do
        get :edit, params: { id: other_project.id }
        expect(response).to redirect_to(root_path)
      end
    end

    context "when project belongs to current user" do
      let!(:project) { create(:project, user: user) }

      it "renders edit template" do
        get :edit, params: { id: project.id }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "PATCH #update" do
    let(:user) { create(:user) }
    before { sign_in user }

    context "when project does not exist" do
      it "renders 404" do
        patch :update, params: { id: 0, projects: { name: "new name" } }
        expect(response).to render_template("application/errors/404")
      end
    end

    context "when project belongs to another user" do
      let(:other_project) { create(:project) }

      it "redirects with alert" do
        patch :update, params: { id: other_project.id, projects: { name: "new name" } }
        expect(response).to redirect_to(root_path)
      end
    end

    context "when project belongs to current user" do
      let!(:project) { create(:project, user: user) }

      context "with empty name" do
        it "renders edit template" do
          patch :update, params: { id: project.id, projects: { name: "" } }
          expect(response).to render_template(:edit)
        end
      end

      context "with valid params" do
        it "redirects to projects path" do
          patch :update, params: { id: project.id, projects: { name: "new name" } }
          expect(response).to redirect_to(projects_path)
        end

        it "updates the project" do
          patch :update, params: { id: project.id, projects: { name: "new name" } }
          expect(project.reload.name).to eq("new name")
        end
      end
    end
  end

  describe "DELETE #destroy" do
    let(:user) { create(:user) }
    before { sign_in user }

    context "when project does not exist" do
      it "renders 404" do
        delete :destroy, params: { id: 0 }
        expect(response).to render_template("application/errors/404")
      end
    end

    context "when project belongs to another user" do
      let!(:other_project) { create(:project) }

      it "redirects with alert" do
        delete :destroy, params: { id: other_project.id }
        expect(response).to redirect_to(root_path)
      end

      it "does not delete the project" do
        expect { delete :destroy, params: { id: other_project.id } }.not_to change(Project, :count)
      end
    end

    context "when project belongs to current user" do
      let!(:project) { create(:project, user: user) }

      it "redirects to projects path" do
        delete :destroy, params: { id: project.id }
        expect(response).to redirect_to(projects_path)
      end

      it "deletes the project" do
        expect { delete :destroy, params: { id: project.id } }.to change(Project, :count).by(-1)
      end
    end
  end
end
