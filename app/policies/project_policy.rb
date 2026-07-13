class ProjectPolicy < ApplicationPolicy
  def index?   = true
  def show?    = owner?
  def create?  = true
  def edit?    = owner?
  def update?  = owner?
  def destroy? = owner?

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(user: user)
    end
  end

  private

  def owner?
    record.user == user
  end
end
