class BasePolicy < ApplicationPolicy
  def index?
    default_policy
  end

  def search?
    default_policy
  end

  def show?
    default_policy
  end

  def new?
    default_policy
  end

  def edit?
    default_policy
  end

  def update?
    default_policy
  end

  def destroy?
    default_policy
  end

  protected

  def default_policy
    return false if user.nil?
    user.admin?
  end
end
