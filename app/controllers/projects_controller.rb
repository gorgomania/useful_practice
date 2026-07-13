class ProjectsController < ApplicationController
  before_action :set_project, only: [ :show, :edit, :update, :destroy ]

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
    @tasks = @project.tasks_by_state
    @states = Project::STATES
  end

  def edit
  end

  def update
    if @project.update(project_params)
      redirect_to projects_path, notice: "Проект успешно обновлен."
    else
      flash.now[:alert] = @project.errors.full_messages.to_sentence
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_path, notice: "Проект успешно удалён."
  end

  private

  def set_project
    @project = Project.find(params[:id])
    authorize @project
  end

  def project_params
    params.require(:projects).permit(:name, :goal, :description)
  end
end
