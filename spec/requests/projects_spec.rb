require "rails_helper"

RSpec.describe "Projects", type: :request do
  describe "GET /projects" do
    context "when user is not logged in" do
      it "redirects to login page" do
        get projects_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is logged in" do
      let(:user) { create(:user) }
      before { sign_in user }

      it "renders the projects page" do
        get projects_path
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Мои проекты")
      end

      it "returns only current user projects" do
        create(:project, name: "own project", user: user)
        create(:project, name: "foreign project")
        get projects_path
        expect(response.body).to include("own project")
        expect(response.body).not_to include("foreign project")
      end

      context "with search query" do
        before do
          create(:project, name: "hegemon", user: user)
          create(:project, name: "something_else", user: user)
        end

        it "filters projects by name" do
          get projects_path, params: { projects: { name: "hegemon" } }
          expect(response.body).to include("Результаты поиска", "hegemon")
          expect(response.body).not_to include("something_else")
        end

        it "does not find projects of other users" do
          create(:project, name: "hegemon of another user")
          get projects_path, params: { projects: { name: "hegemon" } }
          expect(response.body).not_to include("hegemon of another user")
        end
      end
    end
  end

  describe "GET /projects/:id" do
    let(:user) { create(:user) }
    before { sign_in user }

    context "when project does not exist" do
      it "renders 404" do
        get project_path(0)
        expect_not_found_page
      end
    end

    context "when project belongs to another user" do
      let(:other_project) { create(:project) }

      it "renders 404" do
        get project_path(other_project)
        expect_not_found_page
      end
    end

    context "when project belongs to current user" do
      let!(:project) { create(:project, name: "hegemon", user: user) }

      it "renders the project page with its tasks" do
        create(:task, name: "first task", project: project)
        get project_path(project)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("hegemon", "first task")
      end

      it "renders the project page without tasks" do
        get project_path(project)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("В данном проекте задачи отсутствуют.")
      end
    end
  end

  describe "GET /projects/new" do
    context "when user is not logged in" do
      it "redirects to login page" do
        get new_project_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is logged in" do
      let(:user) { create(:user) }
      before { sign_in user }

      it "renders the form" do
        get new_project_path
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Создание проекта")
      end
    end
  end

  describe "POST /projects" do
    let(:user) { create(:user) }
    before { sign_in user }

    context "with empty name" do
      let(:params) { { projects: { name: "", goal: "", description: "" } } }

      it "renders the form again" do
        post projects_path, params: params
        expect(response).to have_http_status(:unprocessable_content)
        expect(response.body).to include("Создание проекта")
      end

      it "does not create project" do
        expect { post projects_path, params: params }.not_to change(Project, :count)
      end
    end

    context "with valid params" do
      let(:params) { { projects: { name: "hegemon", goal: "", description: "" } } }

      it "redirects to projects path" do
        post projects_path, params: params
        expect(response).to redirect_to(projects_path)
      end

      it "creates a project" do
        expect { post projects_path, params: params }.to change(Project, :count).by(1)
      end
    end

    context "with duplicate name" do
      let!(:existing) { create(:project, name: "hegemon", user: user) }
      let(:params) { { projects: { name: "hegemon", goal: "", description: "" } } }

      it "renders the form again" do
        post projects_path, params: params
        expect(response).to have_http_status(:unprocessable_content)
        expect(response.body).to include("Создание проекта")
      end
    end
  end

  describe "GET /projects/:id/edit" do
    let(:user) { create(:user) }
    before { sign_in user }

    context "when project does not exist" do
      it "renders 404" do
        get edit_project_path(0)
        expect_not_found_page
      end
    end

    context "when project belongs to another user" do
      let(:other_project) { create(:project) }

      it "renders 404" do
        get edit_project_path(other_project)
        expect_not_found_page
      end
    end

    context "when project belongs to current user" do
      let!(:project) { create(:project, name: "hegemon", user: user) }

      it "renders the form with current values" do
        get edit_project_path(project)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Изменение проекта", "hegemon")
      end
    end
  end

  describe "PATCH /projects/:id" do
    let(:user) { create(:user) }
    before { sign_in user }

    context "when project does not exist" do
      it "renders 404" do
        patch project_path(0), params: { projects: { name: "new name" } }
        expect_not_found_page
      end
    end

    context "when project belongs to another user" do
      let(:other_project) { create(:project) }

      it "renders 404" do
        patch project_path(other_project), params: { projects: { name: "new name" } }
        expect_not_found_page
      end

      it "does not update the project" do
        expect {
          patch project_path(other_project), params: { projects: { name: "new name" } }
        }.not_to change { other_project.reload.name }
      end
    end

    context "when project belongs to current user" do
      let!(:project) { create(:project, user: user) }

      context "with empty name" do
        it "renders the form again" do
          patch project_path(project), params: { projects: { name: "" } }
          expect(response).to have_http_status(:unprocessable_content)
          expect(response.body).to include("Изменение проекта")
        end
      end

      context "with valid params" do
        it "redirects to projects path" do
          patch project_path(project), params: { projects: { name: "new name" } }
          expect(response).to redirect_to(projects_path)
        end

        it "updates the project" do
          patch project_path(project), params: { projects: { name: "new name" } }
          expect(project.reload.name).to eq("new name")
        end
      end
    end
  end

  describe "DELETE /projects/:id" do
    let(:user) { create(:user) }
    before { sign_in user }

    context "when project does not exist" do
      it "renders 404" do
        delete project_path(0)
        expect_not_found_page
      end
    end

    context "when project belongs to another user" do
      let!(:other_project) { create(:project) }

      it "renders 404" do
        delete project_path(other_project)
        expect_not_found_page
      end

      it "does not delete the project" do
        expect { delete project_path(other_project) }.not_to change(Project, :count)
      end
    end

    context "when project belongs to current user" do
      let!(:project) { create(:project, user: user) }

      it "redirects to projects path" do
        delete project_path(project)
        expect(response).to redirect_to(projects_path)
      end

      it "deletes the project" do
        expect { delete project_path(project) }.to change(Project, :count).by(-1)
      end
    end
  end

  describe "when user is not logged in" do
    let!(:project) { create(:project) }

    it "redirects POST /projects to login page" do
      post projects_path, params: { projects: { name: "new name" } }
      expect(response).to redirect_to(new_user_session_path)
    end

    it "redirects GET /projects/:id to login page" do
      get project_path(project)
      expect(response).to redirect_to(new_user_session_path)
    end

    it "redirects GET /projects/:id/edit to login page" do
      get edit_project_path(project)
      expect(response).to redirect_to(new_user_session_path)
    end

    it "redirects PATCH /projects/:id to login page" do
      patch project_path(project), params: { projects: { name: "new name" } }
      expect(response).to redirect_to(new_user_session_path)
    end

    it "redirects DELETE /projects/:id to login page" do
      delete project_path(project)
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
