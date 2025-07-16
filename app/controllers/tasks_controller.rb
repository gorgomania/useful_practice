class TasksController < ApplicationController
  def new
    @project_id = params[:project_id]
  end

  def show
    redirect_to project_path(params[:project_id])
  end

  def update
    task = Task.find(params[:id])
    task.update(name: task_params[:name])
    if task.save && update_state(task, task_params[:state])
      redirect_to project_path(params[:project_id]), notice: "Задача успешно обновлена."
    else
      @project_id = params[:project_id]
      @name = task_params[:name]
      @task = task
      @options = status_options(task.state)
      if task.errors.size == 0
        flash.now[:alert] = "Недопустимое значение статуса."
      elsif task.errors.messages[:name][0] == "has already been taken"
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
    @state = @task[:state]
    @options = status_options(@state)
  end

  def create
    task = Task.new(project_id: params[:project_id], name: task_params[:name])
    if task.save
      redirect_to project_path(params[:project_id]), notice: "Задача успешно создана."
    else
      if task.errors.messages[:name][0] == "has already been taken"
        flash.now[:alert] = "Имя уже используется."
      else
        flash.now[:alert] = "Имя не может быть пустым."
      end
      @name = task_params[:name]
      @project_id = params[:project_id]
      render "new"
    end
  end
  def destroy
    task_id = params[:id]
    project_id = params[:project_id]
    Task.delete(task_id)
    redirect_to project_path(project_id), notice: "Задача успешно удалена."
  end
  def update_state(task, state)
    if task.state == state.split(" ").join()
      return true
    end
    case state
    when "To Do"
      task.todo
    when "In Progress"
      task.inprogress
    when "In Testing"
      task.intesting
    when "Rejected"
      task.rejected
    when "Done"
      task.done
    else
      false
    end
  end
  def status_options(state)
    case state
    when "ToDo"
      [ "To Do", "In Progress" ]
    when "InProgress"
      [ "In Progress", "In Testing", "To Do" ]
    when "InTesting"
      [ "In Testing", "Done", "Rejected" ]
    when "Rejected"
      [ "Rejected", "In Progress" ]
    else
      [ "Done" ]
    end
  end
  def task_params
    params.require(:tasks).permit(:name, :state)
  end
end
