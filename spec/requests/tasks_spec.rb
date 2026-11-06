require "rails_helper"

RSpec.describe "Tasks", type: :request do
  describe "GET /projects/:project_id/tasks/new" do
    context "when user is not logged in" do
      it "redirects to login page" do
        get new_project_task_path(1)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is logged in" do
      let(:user) { create(:user) }
      before { sign_in user }

      context "when project does not exist" do
        it "renders 404" do
          get new_project_task_path(0)
          expect_not_found_page
        end
      end

      context "when project belongs to another user" do
        let!(:other_project) { create(:project) }

        it "renders 404" do
          get new_project_task_path(other_project)
          expect_not_found_page
        end
      end

      context "when project belongs to current user" do
        let!(:project) { create(:project, user: user) }

        it "renders the form" do
          get new_project_task_path(project)
          expect(response).to have_http_status(:ok)
          expect(response.body).to include("Создание задачи")
        end
      end
    end
  end

  describe "POST /projects/:project_id/tasks" do
    let(:user) { create(:user) }
    before { sign_in user }

    context "when project does not exist" do
      it "renders 404" do
        post project_tasks_path(0), params: { tasks: { name: "hegemon" } }
        expect_not_found_page
      end
    end

    context "when project belongs to another user" do
      let!(:other_project) { create(:project) }

      it "renders 404" do
        post project_tasks_path(other_project), params: { tasks: { name: "hegemon" } }
        expect_not_found_page
      end

      it "does not create task" do
        expect {
          post project_tasks_path(other_project), params: { tasks: { name: "hegemon" } }
        }.not_to change(Task, :count)
      end
    end

    context "when project belongs to current user" do
      let!(:project) { create(:project, user: user) }

      context "with empty name" do
        it "renders the form again" do
          post project_tasks_path(project), params: { tasks: { name: "" } }
          expect(response).to have_http_status(:unprocessable_content)
          expect(response.body).to include("Создание задачи")
        end

        it "does not create task" do
          expect {
            post project_tasks_path(project), params: { tasks: { name: "" } }
          }.not_to change(Task, :count)
        end
      end

      context "with valid name" do
        it "redirects to project" do
          post project_tasks_path(project), params: { tasks: { name: "hegemon" } }
          expect(response).to redirect_to(project_path(project))
        end

        it "creates a task" do
          expect {
            post project_tasks_path(project), params: { tasks: { name: "hegemon" } }
          }.to change(Task, :count).by(1)
        end
      end
    end
  end

  describe "GET /projects/:project_id/tasks/:id/edit" do
    let(:user) { create(:user) }
    before { sign_in user }

    context "when project does not exist" do
      it "renders 404" do
        get edit_project_task_path(0, 1)
        expect_not_found_page
      end
    end

    context "when project belongs to another user" do
      let!(:other_project) { create(:project) }
      let!(:task) { create(:task, project: other_project) }

      it "renders 404" do
        get edit_project_task_path(other_project, task)
        expect_not_found_page
      end
    end

    context "when project belongs to current user" do
      let!(:project) { create(:project, user: user) }

      context "when task does not exist" do
        it "renders 404" do
          get edit_project_task_path(project, 0)
          expect_not_found_page
        end
      end

      context "when task belongs to a project of another user" do
        let!(:foreign_task) { create(:task) }

        it "renders 404" do
          get edit_project_task_path(project, foreign_task)
          expect_not_found_page
        end
      end

      context "when task exists" do
        let!(:task) { create(:task, name: "hegemon", project: project) }

        it "renders the form with current values" do
          get edit_project_task_path(project, task)
          expect(response).to have_http_status(:ok)
          expect(response.body).to include("Изменение задачи", "hegemon")
        end
      end
    end
  end

  describe "PATCH /projects/:project_id/tasks/:id" do
    let(:user) { create(:user) }
    before { sign_in user }

    context "when project does not exist" do
      it "renders 404" do
        patch project_task_path(0, 1), params: { tasks: { name: "hegemon" } }
        expect_not_found_page
      end
    end

    context "when project belongs to another user" do
      let!(:other_project) { create(:project) }
      let!(:task) { create(:task, project: other_project) }

      it "renders 404" do
        patch project_task_path(other_project, task), params: { tasks: { name: "hegemon" } }
        expect_not_found_page
      end

      it "does not update the task" do
        expect {
          patch project_task_path(other_project, task), params: { tasks: { name: "hegemon", state: "In Progress" } }
        }.not_to change { task.reload.name }
      end
    end

    context "when project belongs to current user" do
      let!(:project) { create(:project, user: user) }
      let!(:task) { create(:task, project: project) }

      context "when task does not exist" do
        it "renders 404" do
          patch project_task_path(project, 0), params: { tasks: { name: "hegemon" } }
          expect_not_found_page
        end
      end

      context "when task belongs to a project of another user" do
        let!(:foreign_task) { create(:task) }

        it "renders 404" do
          patch project_task_path(project, foreign_task), params: { tasks: { name: "hegemon" } }
          expect_not_found_page
        end

        it "does not update the task" do
          expect {
            patch project_task_path(project, foreign_task), params: { tasks: { name: "hegemon", state: "In Progress" } }
          }.not_to change { foreign_task.reload.name }
        end
      end

      context "with empty name" do
        it "renders the form again" do
          patch project_task_path(project, task), params: { tasks: { name: "", state: "To Do" } }
          expect(response).to have_http_status(:unprocessable_content)
          expect(response.body).to include("Изменение задачи")
        end
      end

      context "with invalid state" do
        it "renders the form again with an error" do
          patch project_task_path(project, task), params: { tasks: { name: "hegemon", state: "Unknown" } }
          expect(response).to have_http_status(:unprocessable_content)
          expect(response.body).to include("Недопустимое значение статуса")
        end

        it "does not save the new name" do
          expect {
            patch project_task_path(project, task), params: { tasks: { name: "hegemon", state: "Unknown" } }
          }.not_to change { task.reload.name }
        end
      end

      context "with valid params" do
        it "redirects to project" do
          patch project_task_path(project, task), params: { tasks: { name: "hegemon", state: "In Progress" } }
          expect(response).to redirect_to(project_path(project))
        end

        it "updates task name" do
          patch project_task_path(project, task), params: { tasks: { name: "hegemon", state: "In Progress" } }
          expect(task.reload.name).to eq("hegemon")
        end

        it "updates task state" do
          patch project_task_path(project, task), params: { tasks: { name: task.name, state: "In Progress" } }
          expect(task.reload.state).to eq("InProgress")
        end
      end
    end
  end

  describe "DELETE /projects/:project_id/tasks/:id" do
    let(:user) { create(:user) }
    before { sign_in user }

    context "when project does not exist" do
      it "renders 404" do
        delete project_task_path(0, 1)
        expect_not_found_page
      end
    end

    context "when project belongs to another user" do
      let!(:other_project) { create(:project) }
      let!(:task) { create(:task, project: other_project) }

      it "renders 404" do
        delete project_task_path(other_project, task)
        expect_not_found_page
      end

      it "does not delete the task" do
        expect { delete project_task_path(other_project, task) }.not_to change(Task, :count)
      end
    end

    context "when project belongs to current user" do
      let!(:project) { create(:project, user: user) }

      context "when task does not exist" do
        it "renders 404" do
          delete project_task_path(project, 0)
          expect_not_found_page
        end
      end

      context "when task belongs to a project of another user" do
        let!(:foreign_task) { create(:task) }

        it "renders 404" do
          delete project_task_path(project, foreign_task)
          expect_not_found_page
        end

        it "does not delete the task" do
          expect { delete project_task_path(project, foreign_task) }.not_to change(Task, :count)
        end
      end

      context "when task exists" do
        let!(:task) { create(:task, project: project) }

        it "redirects to project" do
          delete project_task_path(project, task)
          expect(response).to redirect_to(project_path(project))
        end

        it "deletes the task" do
          expect { delete project_task_path(project, task) }.to change(Task, :count).by(-1)
        end
      end
    end
  end

  describe "when user is not logged in" do
    let!(:task) { create(:task) }
    let(:project) { task.project }

    it "redirects POST /projects/:project_id/tasks to login page" do
      post project_tasks_path(project), params: { tasks: { name: "hegemon" } }
      expect(response).to redirect_to(new_user_session_path)
    end

    it "redirects GET /projects/:project_id/tasks/:id/edit to login page" do
      get edit_project_task_path(project, task)
      expect(response).to redirect_to(new_user_session_path)
    end

    it "redirects PATCH /projects/:project_id/tasks/:id to login page" do
      patch project_task_path(project, task), params: { tasks: { name: "hegemon" } }
      expect(response).to redirect_to(new_user_session_path)
    end

    it "redirects DELETE /projects/:project_id/tasks/:id to login page" do
      delete project_task_path(project, task)
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
