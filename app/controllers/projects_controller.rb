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
    @project = Project.new
  end

  def create
    @project = Project.new(project_params.merge(user: current_user))
    authorize @project

    if @project.save
      redirect_to projects_path, notice: "Проект успешно создан."
    else
      flash.now[:alert] = @project.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @project = Project.find(params[:id])
    authorize @project

    tasks = @project.tasks
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

  def edit
    @project = Project.find(params[:id])
    authorize @project
  end

  def update
    @project = Project.find(params[:id])
    authorize @project
    if @project.update(project_params)
      redirect_to projects_path, notice: "Проект успешно обновлен."
    else
      flash.now[:alert] = @project.errors.full_messages.to_sentence
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    project = Project.find(params[:id])
    authorize project
    project.destroy
    redirect_to projects_path, notice: "Проект успешно удалён."
  end

  private

  def project_params
    params.require(:projects).permit(:name, :goal, :description)
  end
end
