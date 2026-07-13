class TaskPolicy < ApplicationPolicy
  def show?    = project_owner?
  def create?  = project_owner?
  def update?  = project_owner?
  def destroy? = project_owner?

  private

  def project_owner?
    record.project.user == user
  end
end
