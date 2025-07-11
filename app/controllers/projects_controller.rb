class ProjectsController < ApplicationController
  def index
    @projects = current_user.project
    @search_query = nil
  end

  def create
    name = project_params[:name]
    goal = project_params[:goal]
    description = project_params[:description]
    project = Project.new(user: current_user, name: name, goal: goal, description: description)
    if project.save
      redirect_to projects_path, notice: "Проект успешно создан."
    else
      if project.errors.messages[:name][0] == "has already been taken"
        flash.now[:alert] = "Имя уже используется."
      else
        flash.now[:alert] = "Имя не может быть пустым."
      end
      @name = name
      @goal = goal
      @description = description
      render "new"
    end
  end

  def new
    @name = nil
    @goal = nil
    @description = nil
  end

  def show
    @project = Project.find(params[:id])
    @tasks = @project.task
  end

  def project_params
    params.require(:projects).permit(:name, :goal, :desсription)
  end
end
