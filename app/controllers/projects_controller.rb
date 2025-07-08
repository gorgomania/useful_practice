class ProjectsController < ApplicationController
  def index
    @error = false
    @name = nil
    @goal = nil
    @description = nil
  end
  def create
    name = params[:projects][:name]
    goal = params[:projects][:goal]
    description = params[:projects][:description]
    project = current_user.project.create(name: name, goal: goal, description: description)
    if project.id == nil
      @error = true
      @name = name
      @goal = goal
      @description = description
      render "new"
    else
      redirect_to "/projects"
    end
  end
  def new
  end
end
