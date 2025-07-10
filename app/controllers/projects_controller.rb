class ProjectsController < ApplicationController
  def index
    @name = nil
    @goal = nil
    @description = nil
    @projects = current_user.project
    @search_query = nil
  end
  def create
    name = project_params[:name]
    goal = project_params[:goal]
    description = project_params[:description]
    project = Project.new(user: current_user, name: name, goal: goal, description: description)
    if project.save
      redirect_to "/projects", notice: "Проект успешно создан."
    else
      @name = name
      @goal = goal
      @description = description
      if project.errors.messages[:name][0] == "has already been taken"
        flash.now[:alert] = "Имя уже используется."
      else
        flash.now[:alert] = "Необходимо определить имя."
      end
      render "new"
    end
  end
  def new
  end

  def show
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:projects).permit(:name, :goal, :desсription)
  end
end
