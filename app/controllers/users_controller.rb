class UsersController < ApplicationController
  def index
    authorize current_user, policy_class: UserPolicy
  end
end
