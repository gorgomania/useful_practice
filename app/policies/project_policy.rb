class ProjectPolicy < ApplicationPolicy
  def index?  = true
  def create? = true

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(user: user)
    end
  end
end
