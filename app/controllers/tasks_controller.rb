class TasksController < ApplicationController
  before_action :set_project
  before_action :set_task, only: [ :show, :edit, :update, :destroy ]

  def show
    redirect_to project_path(@project)
  end

  def new
    authorize @project.tasks.new
  end

  def create
    @task = @project.tasks.new(task_params)
    authorize @task

    if @task.save
      redirect_to project_path(@project), notice: "Задача успешно создана"
    else
      @name = task_params[:name]
      flash.now[:alert] = @task.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @name = @task.name
    @state = @task[:state]
    @options = status_options(@state)
  end

  def update
    if @task.update(name: task_params[:name]) && update_state(@task, task_params[:state])
      redirect_to project_path(@project), notice: "Задача успешно обновлена"
    else
      @options = status_options(@task.state)
      flash.now[:alert] = if @task.errors.any?
        @task.errors.full_messages.to_sentence
      else
        "Недопустимое значение статуса"
      end
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    redirect_to project_path(@project), notice: "Задача успешно удалена"
  end

  private

  def set_project
    @project = policy_scope(Project).find(params[:project_id])
  end

  def set_task
    @task = @project.tasks.find(params[:id])
    authorize @task
  end

  def update_state(task, state)
    if state && task.state == state.split(" ").join()
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
