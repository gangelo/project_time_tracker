class UserPolicy < ApplicationPolicy
=begin
  class Scope < Scope
    def initialize(user, scope)
      super
    end

    def resolve
      case
      when user.admin?
        scope.all
      else
        # TODO: ?
      end
    end
  end
=end

  def index?
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

  protected

  def default_policy
    return false if user.nil?
    user.admin?
  end
end
