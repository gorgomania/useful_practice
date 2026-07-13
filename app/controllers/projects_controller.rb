class ProjectsController < ApplicationController
  def index
    search = params.dig(:projects, :name)
    if search.present?
      @projects = policy_scope(Project).where("name ILIKE ?", "%#{search}%")
      @search_query = search
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

    @tasks = @project.tasks_by_state
    @states = Project::STATES
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
