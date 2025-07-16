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
    if @project.user_id == current_user.id
      tasks = @project.task
      todo = []
      inprogress = []
      intesting = []
      rejected = []
      done = []
      tasks.each do |task|
      case task[:state]
      when "ToDo"
          todo.push(task)
      when "InProgress"
          inprogress.push(task)
      when "InTesting"
          intesting.push(task)
      when "Rejected"
          rejected.push(task)
      else
          done.push(task)
      end
      end
      size = [ todo.size, inprogress.size, intesting.size, rejected.size, done.size ].max
      @tasks = []
      size.times do |i|
        @tasks.push(todo[i])
        @tasks.push(inprogress[i])
        @tasks.push(intesting[i])
        @tasks.push(rejected[i])
        @tasks.push(done[i])
      end
      @states = [ "To Do", "In Progress", "In Testing", "Rejected", "Done" ]
    else
      redirect_to projects_path, alert: "В доступе отказано."
    end
  end

  def project_params
    params.require(:projects).permit(:name, :goal, :desсription)
  end
end
