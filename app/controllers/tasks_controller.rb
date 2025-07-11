class TasksController < ApplicationController
  def new
    @project_id = params[:project_id]
  end

  def update
    task = Task.find(params[:id])
    old_status = task.status
    status = task_params[:status]
    name = task_params[:name]
    task.update(name: name, status: status)
    if task.save
      redirect_to project_path(params[:project_id]), notice: "Задача успешно обновлена."
    else
      @project_id = params[:project_id]
      @name = name
      @task = task
      @options = status_options(old_status)
      if task.errors.messages[:name][0] == "has already been taken"
         flash.now[:alert] = "Имя уже используется."
      else
         flash.now[:alert] = "Имя не может быть пустым."
      end
      render "edit"
    end
  end

  def edit
    @project_id = params[:project_id]
    @task = Task.find(params[:id])
    @name = @task.name
    @status = @task.status
    @options = status_options(@status)
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
        flash.now[:alert] = "Имя не может быть пустым."
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
  def status_options(status)
    case status
    when "To Do"
      [ "To Do", "In Progress" ]
    when "In Progress"
      [ "In Progress", "In Testing", "To Do" ]
    when "In Testing"
      [ "In Testing", "Done", "Rejected" ]
    when "Rejected"
      [ "Rejected", "In Progress" ]
    else
      [ "Done" ]
    end
  end
  def task_params
    params.require(:tasks).permit(:name, :status)
  end
end
