class TasksController < ApplicationController
  def new
    @project_id = params[:project_id]
  end

  def edit
  end

  def create
    name = task_params[:name]
    project_id = params[:project_id]
    project = Project.find(project_id)
    task = Task.new(project: project, name: name)
    if task.save
      redirect_to project_path(project_id), notice: "Задача успешно создана."
    else
      if task.errors.messages[:name][0] == "has already been taken"
        flash.now[:alert] = "Имя уже используется."
      else
        flash.now[:alert] = "Необходимо определить имя."
      end
      @name = name
      @project_id = project_id
      render "new"
    end
  end
  def destroy
    task_id = params[:id]
    project_id = params[:project_id]
    Task.delete(task_id)
    redirect_to project_path(project_id), notice: "Задача успешно удалена."
  end
  def task_params
    params.require(:tasks).permit(:name)
  end
end
