class ProjectsController < ApplicationController
  def index
    if params[:projects] && project_params[:name] != ""
      like_params = "%#{project_params[:name]}%"
      @projects = policy_scope(Project).where("name ILIKE ?", like_params)
      @search_query = project_params[:name]
    else
      @projects = policy_scope(Project)
      @search_query = nil
    end
  end

  def new
    @name = nil
    @goal = nil
    @description = nil
  end

  def create
    @project = Project.new(project_params.merge(user: current_user))
    authorize @project

    if @project.save
      redirect_to projects_path, notice: "Проект успешно создан"
    else
      flash.now[:alert] = @project.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @project = Project.find(params[:id])
    authorize @project

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
  end

  private

  def project_params
    params.require(:projects).permit(:name, :goal, :description)
  end
end
